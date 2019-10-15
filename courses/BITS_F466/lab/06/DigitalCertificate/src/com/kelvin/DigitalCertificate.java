/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kelvin;

import java.io.FileInputStream;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.Certificate;
import javax.crypto.Cipher;
/**
 *
 * @author Admin
 */
public class DigitalCertificate {

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

                // Perform encyrpyion
                System.out.println("PERFORMING ENCRYPTION");
                byte[] pBytes = "SOC Lab is on time!".getBytes();
                System.out.println("\tPlain Text : " + new String(pBytes));
                c.init(Cipher.ENCRYPT_MODE, kp.getPublic());
                byte[] cBytes = c.doFinal(pBytes);
                System.out.println("\tCipher Text : " + new String(cBytes) + "\n");

                // Perform decryption
                System.out.println("PERFORMING DECRYPTION");
                c.init(Cipher.DECRYPT_MODE, kp.getPrivate());
                byte[] dBytes = c.doFinal(cBytes);
                System.out.println("\tDecrytpion : " + new String(dBytes) + "\n");
            }
    }
    
}
