package com.jobify;

import com.jobify.model.Job;
import com.jobify.model.Role;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class JobModelTest {

    @Test
    @DisplayName("Should correctly format salary ranges and zero salaries")
    void testFormattedSalary() {
        Job job = new Job();

        // 1. Both zero
        job.setSalaryMin(BigDecimal.ZERO);
        job.setSalaryMax(BigDecimal.ZERO);
        assertEquals("Competitive", job.getFormattedSalary());

        // 2. Only max provided
        job.setSalaryMin(BigDecimal.ZERO);
        job.setSalaryMax(BigDecimal.valueOf(80000));
        assertTrue(job.getFormattedSalary().contains("Up to"));

        // 3. Min and Max range
        job.setSalaryMin(BigDecimal.valueOf(70000));
        job.setSalaryMax(BigDecimal.valueOf(95000));
        assertTrue(job.getFormattedSalary().contains("70,000") && job.getFormattedSalary().contains("95,000"));

        // 4. Equal min and max
        job.setSalaryMin(BigDecimal.valueOf(60000));
        job.setSalaryMax(BigDecimal.valueOf(60000));
        assertTrue(job.getFormattedSalary().contains("60,000 / yr"));
    }

    @Test
    @DisplayName("Should parse skills list from comma-separated string")
    void testSkillListParsing() {
        Job job = new Job();
        job.setSkillsRequired("Java,   MySQL, Jakarta Servlets,  REST API ");

        List<String> list = job.getSkillList();
        assertEquals(4, list.size());
        assertEquals("Java", list.get(0));
        assertEquals("MySQL", list.get(1));
        assertEquals("Jakarta Servlets", list.get(2));
        assertEquals("REST API", list.get(3));
    }

    @Test
    @DisplayName("Should parse Role enum safely")
    void testRoleEnum() {
        assertEquals(Role.JOB_SEEKER, Role.fromString("JOB_SEEKER"));
        assertEquals(Role.EMPLOYER, Role.fromString("employer"));
        assertEquals(Role.ADMIN, Role.fromString("ADMIN"));
        assertNull(Role.fromString("INVALID_ROLE"));
        assertNull(Role.fromString(null));
    }
}
