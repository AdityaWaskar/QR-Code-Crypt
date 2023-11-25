package com.example.qr_code_crypt; 
 
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import org.bouncycastle.util.encoders.Base64;
import java.nio.charset.StandardCharsets;

import java.security.*;
import java.security.spec.X509EncodedKeySpec;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import org.bouncycastle.crypto.engines.ChaCha7539Engine;
import org.bouncycastle.crypto.generators.PKCS5S2ParametersGenerator;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.crypto.params.ParametersWithIV;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.qr_code_crypt/crypto";
    private static final int KEY_LENGTH_BITS = 256;
    private static final String KEY_ALIAS = "ECKeyPairAlias";
    private static final boolean development = true;  
    private static final int ITERATION_COUNT = 10000;
    private static final int NONCE_LENGTH = 12; // Use the same length for nonce in bytes


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("encrypt")) {
                                String plainText = call.argument("plainText");
                                String password = call.argument("password");
                                // Handle encryption with digital signature method call
                                try { 
                                    //* Encrypting the given Data
                                    String encryptedText = encrypt(plainText, password);
                                    print(development, "crypto", "Encrypted Text : "+encryptedText);  
                                    result.success(encryptedText);
                                } catch (Exception e) {
                                    result.error("ENCRYPTION_ERROR", e.getMessage(), null);
                                }
                            }else if(call.method.equals("decrypt")){
                                String info = call.argument("info");
                                String password = call.argument("password");

                                Map<String, Object> resultMap = new HashMap<>();
                                try {
                                    resultMap = stringToMap(info);
                                    // Rest of your code
                                } catch (IOException e) {
                                    // Handle the IOException (e.g., log the error, throw a custom exception, etc.)
                                    e.printStackTrace();
                                }
                                String cipherText = (String) resultMap.get("cipherText");
                                byte[] keyBytes = Base64.decode((String) resultMap.get("keyBytes"));
                                byte[] nonceBytes = Base64.decode((String) resultMap.get("noncebytes"));
                                byte[] publicKeyBytes = Base64.decode((String) resultMap.get("pubicKey")) ;
                                byte[] signatureBytes = Base64.decode((String) resultMap.get("signature"));

                                try {
                                    //* verify the digital signature 
                                    boolean isVerify = verifySignature(cipherText, publicKeyBytes, signatureBytes); 
                                    if(isVerify){
                                        //* decrypting the data
                                        String decryptedText = decrypt(cipherText, keyBytes, nonceBytes);
                                        print(development, "crypto", "Decryted Text : "+ decryptedText);
                                        result.success(decryptedText);
                                    }else{
                                        result.success("Some error occured while verifying !");
                                    }
                                } catch (Exception e) { 
                                    result.error("Verfying_error", e.getMessage(), null);
                                }
                            }else {
                                // Handle other method calls
                                result.notImplemented();
                            }
                        }
                );
    }

    private static void print(boolean value, String name, String msg){
        if(value){
            Log.d(name, msg);
        }
    } 

    // Encrypt the plaintext
    private String encrypt(String plainText, String password) throws Exception {
        byte[] keyBytes = deriveKeyFromPassword(password);
        byte[] nonceBytes = generateNonce();

        ChaCha7539Engine cipher = new ChaCha7539Engine();
        cipher.init(true, new ParametersWithIV(new KeyParameter(keyBytes), nonceBytes));

        byte[] plainTextBytes = plainText.getBytes(StandardCharsets.UTF_8);
        byte[] cipherText = new byte[plainTextBytes.length];

        cipher.processBytes(plainTextBytes, 0, plainTextBytes.length, cipherText, 0);

        // Concatenate the nonce and cipherText into a single byte array
        byte[] resultBytes = new byte[nonceBytes.length + cipherText.length];
        System.arraycopy(nonceBytes, 0, resultBytes, 0, nonceBytes.length);
        System.arraycopy(cipherText, 0, resultBytes, nonceBytes.length, cipherText.length);

        //generate keyPair 
        KeyPair keyPair = generateECCKeyPair();
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("cipherText", Base64.toBase64String(resultBytes));
        resultMap.put("keyBytes", Base64.toBase64String(keyBytes));
        resultMap.put("noncebytes", Base64.toBase64String(nonceBytes));
        resultMap.put("pubicKey", Base64.toBase64String(keyPair.getPublic().getEncoded()));
    
        // * Sign the encrypted text and store into the map
        String signature = signText(Base64.toBase64String(resultBytes), keyPair);
        resultMap.put("signature", signature);
        return mapToString(resultMap);
    }

    // Decrypt the ciphertext
    private String decrypt(String cipherText, byte[] keyBytes, byte[] nonceBytes) throws Exception {
         
        byte[] inputBytes = Base64.decode(cipherText);
        byte[] cipherBytes = new byte[inputBytes.length - NONCE_LENGTH];

        System.arraycopy(inputBytes, 0, nonceBytes, 0, NONCE_LENGTH);
        System.arraycopy(inputBytes, NONCE_LENGTH, cipherBytes, 0, cipherBytes.length);

        ChaCha7539Engine cipher = new ChaCha7539Engine();
        cipher.init(false, new ParametersWithIV(new KeyParameter(keyBytes), nonceBytes));

        byte[] decryptedText = new byte[cipherBytes.length];

        cipher.processBytes(cipherBytes, 0, cipherBytes.length, decryptedText, 0);

        return new String(decryptedText, StandardCharsets.UTF_8);
    }

    // Derive key from password
    private byte[] deriveKeyFromPassword(String password) {
        PKCS5S2ParametersGenerator generator = new PKCS5S2ParametersGenerator();
        generator.init(password.getBytes(StandardCharsets.UTF_8), generateSalt(), ITERATION_COUNT);
        return ((KeyParameter) generator.generateDerivedParameters(KEY_LENGTH_BITS)).getKey();
    }

    // Generate a unique nonce
    private byte[] generateNonce() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] nonce = new byte[NONCE_LENGTH];
        secureRandom.nextBytes(nonce);
        return nonce;
    }

    // Generate a unique salt
    private byte[] generateSalt() {
        SecureRandom secureRandom = new SecureRandom();
        byte[] salt = new byte[16];
        secureRandom.nextBytes(salt);
        return salt;
    }
    private static KeyPair generateECCKeyPair() throws Exception {
        try {
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(
                    KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore");
    
            KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
                    KEY_ALIAS,
                    KeyProperties.PURPOSE_SIGN | KeyProperties.PURPOSE_VERIFY)
                    .setDigests(KeyProperties.DIGEST_SHA256)
                    .setKeySize(KEY_LENGTH_BITS)
                    .build();
    
            keyPairGenerator.initialize(keyGenParameterSpec);
            Log.d("S", "Success");
    
            KeyPair keyPair = keyPairGenerator.generateKeyPair();
    
            // Log information about the private key
            String privateAlgorithm = keyPair.getPrivate().getAlgorithm();
            String privateFormat = keyPair.getPrivate().getFormat();
            Log.d("PrivateKeyInfo", "Algorithm: " + privateAlgorithm + ", Format: " + privateFormat);
    
            // Log the public key as a Base64-encoded string
            String publicKeyString = Base64.toBase64String(keyPair.getPublic().getEncoded());
            Log.d("PublicKeyInfo", "Public Key: " + publicKeyString);
    
            return keyPair;
        } catch (Exception e) {
            Log.d("S", "Error");
            Log.e("KeyPairGenerationError", "Error generating ECC key pair", e);
            throw e;
        }
    }
    
    
    private static String signText(String cipherText, KeyPair keyPair) throws Exception {

        // initilizing publicKey and privateKey
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();
        // Sign the plaintext using the private key
        Signature signature = Signature.getInstance("SHA256withECDSA");
        signature.initSign(privateKey);
        signature.update(cipherText.getBytes(StandardCharsets.UTF_8));
    
        // Get the signature bytes and encode as Base64
        byte[] signatureBytes = signature.sign();

        // Converting the signature into string and return.
        return Base64.toBase64String(signatureBytes);
    }

    private static boolean verifySignature(String cipherText, byte[] publicKeyBytes, byte[] signatureBytes) {
        try { 

            // Create a PublicKey object from the encoded public key
            KeyFactory keyFactory = KeyFactory.getInstance("EC");
            PublicKey publicKey = keyFactory.generatePublic(new X509EncodedKeySpec(publicKeyBytes));

            // Initialize Signature object with the public key and update with the cipher text
            Signature verifier = Signature.getInstance("SHA256withECDSA");
            verifier.initVerify(publicKey);
            verifier.update(cipherText.getBytes(StandardCharsets.UTF_8));
            
            // Verify the signature 
            return verifier.verify(signatureBytes);
        } catch (Exception e) {
            Log.e("SignatureVerificationError", "Error verifying signature", e);
            return false;
        }
    }
 

    private static String mapToString(Map<String, Object> map) throws Exception {
                ObjectMapper objectMapper = new ObjectMapper();
                return objectMapper.writeValueAsString(map);
    } 
 

    // Convert JSON string to Map
    private static Map<String, Object> stringToMap(String jsonString) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(jsonString, Map.class);
    }
}
