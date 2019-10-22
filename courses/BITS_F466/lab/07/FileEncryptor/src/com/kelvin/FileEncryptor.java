/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kelvin;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.Certificate;
import javax.crypto.Cipher;
import java.io.File;
import java.nio.file.Files;

/**
 *
 * @author Admin
 */
public class FileEncryptor {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
            FileInputStream is = new FileInputStream("../kelvin.keystore");

            KeyStore keystore = KeyStore.getInstance(KeyStore.getDefaultType());
            keystore.load(is, "123abc".toCharArray());

            String alias = "kelvin_keypair";

            Key key = keystore.getKey(alias, "abc123".toCharArray());
            if (key instanceof PrivateKey) {
                Certificate cert = keystore.getCertificate(alias);
                PublicKey publicKey = cert.getPublicKey();

                KeyPair kp = new KeyPair(publicKey, (PrivateKey) key);
                Cipher c = Cipher.getInstance("RSA/ECB/PKCS1Padding");

                // Read file
                System.out.println("READING FILE");
                // This is a very confidential bit of information.
                String filename = "../message.txt";
                File file = new File(filename);
                byte[] fBytes = Files.readAllBytes(file.toPath());
                System.out.println("File              : " + filename);
                System.out.println("Content           :\n" + new String(fBytes));
                
                // Perform encyrpyion
                System.out.println("\nPERFORMING ENCRYPTION");
                c.init(Cipher.ENCRYPT_MODE, kp.getPublic());
                byte[] cBytes = c.doFinal(fBytes);
                String encryptedFilename = "../encrypted.txt";
                System.out.println("Encrypted File    : " + encryptedFilename);
                System.out.println("Content           :\n" + new String(cBytes));
                
                // Write file
                System.out.println("\nWRITING FILE");
                try (FileOutputStream stream = new FileOutputStream(encryptedFilename)) {
                    stream.write(cBytes);
                }

                // Read file
                System.out.println("\nREADING FILE");
                File efile = new File(encryptedFilename);
                byte[] eBytes = Files.readAllBytes(efile.toPath());
                System.out.println("File              : " + encryptedFilename);
                System.out.println("Content           :\n" + new String(eBytes));
                
                // Perform decryption
                
                System.out.println("\nPERFORMING DECRYPTION");
                c.init(Cipher.DECRYPT_MODE, kp.getPrivate());
                byte[] dBytes = c.doFinal(eBytes);
                String decryptedFilename = "../decrypted.txt";
                System.out.println("Decrypted File    : " + decryptedFilename);
                System.out.println("Content           :\n" + new String(dBytes));

                // Write file
                System.out.println("\nWRITING FILE");
                try (FileOutputStream stream = new FileOutputStream(decryptedFilename)) {
                    stream.write(dBytes);
                }
            }
    }
    
}
