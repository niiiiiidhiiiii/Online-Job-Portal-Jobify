package com.jobify;

import com.jobify.model.Job;
import com.jobify.model.JobSeekerProfile;
import com.jobify.service.RecommendationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class RecommendationServiceTest {

    private RecommendationService recommendationService;

    @BeforeEach
    void setUp() {
        recommendationService = new RecommendationService();
    }

    @Test
    @DisplayName("Should return 100% match when all required skills are present")
    void testExactMatch() {
        String seekerSkills = "Java, MySQL, Spring Boot";
        String jobSkills = "Java, MySQL, Spring Boot";

        int score = recommendationService.calculateMatchScore(seekerSkills, jobSkills);
        assertEquals(100, score);
    }

    @Test
    @DisplayName("Should handle skill aliases and normalization (e.g. ReactJS -> React, JS -> JavaScript)")
    void testSkillAliases() {
        String seekerSkills = "ReactJS, JS, Postgres";
        String jobSkills = "React, JavaScript, PostgreSQL";

        int score = recommendationService.calculateMatchScore(seekerSkills, jobSkills);
        assertEquals(100, score);
    }

    @Test
    @DisplayName("Should calculate partial match score accurately")
    void testPartialMatch() {
        String seekerSkills = "Java, HTML, CSS";
        String jobSkills = "Java, Spring Boot, MySQL, Docker"; // 1 out of 4 matched

        int score = recommendationService.calculateMatchScore(seekerSkills, jobSkills);
        assertEquals(25, score);
    }

    @Test
    @DisplayName("Should return 0 for completely unrelated skills or empty inputs")
    void testZeroMatch() {
        assertEquals(0, recommendationService.calculateMatchScore("Photoshop, Video Editing", "Java, Docker, Kubernetes"));
        assertEquals(0, recommendationService.calculateMatchScore(null, "Java"));
        assertEquals(0, recommendationService.calculateMatchScore("Java", null));
    }

    @Test
    @DisplayName("Should rank jobs in descending order of match percentage")
    void testJobRanking() {
        JobSeekerProfile profile = new JobSeekerProfile();
        profile.setSkills("Java, MySQL, Spring Boot");

        Job jobLow = new Job();
        jobLow.setId(1);
        jobLow.setTitle("Frontend Designer");
        jobLow.setSkillsRequired("Figma, CSS, HTML, JavaScript"); // 0 match

        Job jobMed = new Job();
        jobMed.setId(2);
        jobMed.setTitle("Full Stack Junior");
        jobMed.setSkillsRequired("Java, React, Node, Docker"); // 1 match (25%)

        Job jobHigh = new Job();
        jobHigh.setId(3);
        jobHigh.setTitle("Backend Java Lead");
        jobHigh.setSkillsRequired("Java, MySQL, Spring Boot, AWS"); // 3 of 4 match (75%)

        List<Job> allJobs = new ArrayList<>();
        allJobs.add(jobLow);
        allJobs.add(jobMed);
        allJobs.add(jobHigh);

        List<Job> recommendations = recommendationService.getRecommendedJobs(profile, allJobs);

        assertEquals(2, recommendations.size()); // Zero matches filtered out
        assertEquals(3, recommendations.get(0).getId()); // Highest match first
        assertEquals(75, recommendations.get(0).getMatchScore());
        assertEquals(2, recommendations.get(1).getId());
        assertEquals(25, recommendations.get(1).getMatchScore());
    }
}
