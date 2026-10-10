package com.jobify;

import com.jobify.util.PasswordUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    @DisplayName("Should hash and verify password successfully")
    void testHashAndVerifyPassword() {
        String rawPassword = "Admin@123";
        String hash = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$"));
        assertTrue(PasswordUtil.checkPassword(rawPassword, hash));
        assertFalse(PasswordUtil.checkPassword("WrongPassword", hash));
    }

    @Test
    @DisplayName("Should generate different salt for different hashes of same password")
    void testUniqueSalts() {
        String raw = "SecurePass123!";
        String hash1 = PasswordUtil.hashPassword(raw);
        String hash2 = PasswordUtil.hashPassword(raw);

        assertNotEquals(hash1, hash2);
        assertTrue(PasswordUtil.checkPassword(raw, hash1));
        assertTrue(PasswordUtil.checkPassword(raw, hash2));
    }

    @Test
    @DisplayName("Should print hashes for demo accounts")
    void testPrintDemoHashes() {
        System.out.println("DEMO_ADMIN_HASH: " + PasswordUtil.hashPassword("Admin@123"));
        System.out.println("DEMO_EMP_HASH: " + PasswordUtil.hashPassword("Employer@123"));
        System.out.println("DEMO_SEEKER_HASH: " + PasswordUtil.hashPassword("Seeker@123"));
    }
}
