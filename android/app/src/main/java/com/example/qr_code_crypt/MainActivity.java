package com.example.qr_code_crypt; 

import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;

import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.bouncycastle.crypto.engines.ChaCha7539Engine;
import org.bouncycastle.crypto.generators.PKCS5S2ParametersGenerator;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.crypto.params.ParametersWithIV;
import org.bouncycastle.util.encoders.Base64;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.qr_code_crypt/crypto";
    private static final int KEY_LENGTH_BITS = 256;
    private static final int ITERATION_COUNT = 10000;
    private static final int NONCE_LENGTH = 12; // Use the same length for nonce in bytes
 

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("encrypt")) {
                        // Handle encryption method call
                        String plainText = call.argument("userText");
                        String password = call.argument("userPass");

                        try {
                            String encryptedText = encrypt(plainText, password);
                            result.success(encryptedText);
                        } catch (Exception e) {
                            result.error("ENCRYPTION_ERROR", e.getMessage(), null);
                        }
                    } else if (call.method.equals("decrypt")) {
                        // Handle decryption method call
                        String cipherText = call.argument("cipherText");
                        String password = call.argument("_userPass"); // Use userPass instead of _userPass

                        try {
                            String decryptedText = decrypt(cipherText, password);
                            result.success(decryptedText);
                        } catch (Exception e) {
                            result.error("DECRYPTION_ERROR", e.getMessage(), null);
                        }
                    } else {
                        // Handle other method calls
                        result.notImplemented();
                    }
                }
            );
    }

    // Convert Map to JSON string
    private static String mapToString(Map<String, Object> map) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(map);
    }

    // Convert JSON string to Map
    private static Map<String, Object> stringToMap(String jsonString) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(jsonString, Map.class);
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

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("cipherText", Base64.toBase64String(resultBytes));
        resultMap.put("keyBytes", Base64.toBase64String(keyBytes));
        resultMap.put("noncebytes", Base64.toBase64String(nonceBytes));
        return mapToString(resultMap);
    }

    // Decrypt the ciphertext
    private String decrypt(String cipherText, String password) throws Exception {
        Map<String, Object> resultMap = stringToMap(cipherText);
        cipherText = (String) resultMap.get("cipherText");
        byte[] keyBytes = Base64.decode((String) resultMap.get("keyBytes"));
        byte[] nonceBytes = Base64.decode((String) resultMap.get("noncebytes"));

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
}
