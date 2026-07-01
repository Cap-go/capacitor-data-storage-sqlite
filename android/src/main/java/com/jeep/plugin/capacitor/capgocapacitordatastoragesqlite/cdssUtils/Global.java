package com.jeep.plugin.capacitor.capgocapacitordatastoragesqlite.cdssUtils;

public class Global {

    private static final String DEFAULT_SECRET = "test secret";
    private static final String DEFAULT_NEW_SECRET = "test new secret";

    private static String secretDefault = DEFAULT_SECRET;
    private static String newSecretDefault = DEFAULT_NEW_SECRET;

    public String secret;
    public String newsecret;

    public Global() {
        secret = secretDefault;
        newsecret = newSecretDefault;
    }

    public static void configure(String secret, String newSecret) {
        if (secret != null && !secret.isEmpty()) {
            secretDefault = secret;
        }
        if (newSecret != null && !newSecret.isEmpty()) {
            newSecretDefault = newSecret;
        }
    }
}
