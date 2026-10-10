package com.jobify;

import com.jobify.util.ValidationUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.math.BigDecimal;
import java.sql.Date;

import static org.junit.jupiter.api.Assertions.*;

public class ValidationUtilTest {

    @ParameterizedTest
    @ValueSource(strings = {"test@jobify.com", "admin.user@college.edu", "first.last+tag@company.co.in"})
    @DisplayName("Should accept valid email formats")
    void testValidEmails(String email) {
        assertTrue(ValidationUtil.isValidEmail(email));
    }

    @ParameterizedTest
    @ValueSource(strings = {"plainaddress", "missing@domain", "@nodomain.com", "spaces in@mail.com", "", "   "})
    @DisplayName("Should reject invalid email formats")
    void testInvalidEmails(String email) {
        assertFalse(ValidationUtil.isValidEmail(email));
    }

    @Test
    @DisplayName("Should validate password length")
    void testPasswordValidation() {
        assertTrue(ValidationUtil.isValidPassword("secret123"));
        assertTrue(ValidationUtil.isValidPassword("123456"));
        assertFalse(ValidationUtil.isValidPassword("12345"));
        assertFalse(ValidationUtil.isValidPassword(null));
        assertFalse(ValidationUtil.isValidPassword(""));
    }

    @Test
    @DisplayName("Should sanitize HTML to prevent XSS injection")
    void testSanitizeXSS() {
        String input = "<script>alert('pwned');</script>&\"test\"";
        String sanitized = ValidationUtil.sanitize(input);

        assertFalse(sanitized.contains("<script>"));
        assertTrue(sanitized.contains("&lt;script&gt;"));
        assertTrue(sanitized.contains("&quot;"));
        assertTrue(sanitized.contains("&#x27;"));
    }

    @Test
    @DisplayName("Should parse numbers safely with fallback")
    void testNumberParsing() {
        assertEquals(42, ValidationUtil.parseInt("42", 0));
        assertEquals(10, ValidationUtil.parseInt("invalid", 10));
        assertEquals(10, ValidationUtil.parseInt(null, 10));

        BigDecimal bd = ValidationUtil.parseBigDecimal("75,000.50", BigDecimal.ZERO);
        assertEquals(new BigDecimal("75000.50"), bd);

        BigDecimal fallback = ValidationUtil.parseBigDecimal("invalid", BigDecimal.valueOf(100));
        assertEquals(BigDecimal.valueOf(100), fallback);
    }

    @Test
    @DisplayName("Should parse date correctly")
    void testDateParsing() {
        Date d = ValidationUtil.parseDate("2026-11-30");
        assertNotNull(d);
        assertEquals("2026-11-30", d.toString());

        assertNull(ValidationUtil.parseDate("invalid-date"));
        assertNull(ValidationUtil.parseDate(null));
    }
}
