package com.jobify.service;

import com.jobify.model.Job;
import com.jobify.model.JobSeekerProfile;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Service that provides skill-based job recommendations for Job Seekers.
 * Uses a tokenized matching algorithm with alias normalization and overlap scoring.
 */
public class RecommendationService {

    private static final Map<String, String> SKILL_ALIASES = new HashMap<>();

    static {
        SKILL_ALIASES.put("js", "javascript");
        SKILL_ALIASES.put("reactjs", "react");
        SKILL_ALIASES.put("vuejs", "vue");
        SKILL_ALIASES.put("nodejs", "node");
        SKILL_ALIASES.put("ts", "typescript");
        SKILL_ALIASES.put("py", "python");
        SKILL_ALIASES.put("postgres", "postgresql");
        SKILL_ALIASES.put("golang", "go");
        SKILL_ALIASES.put("k8s", "kubernetes");
        SKILL_ALIASES.put("ui/ux", "ui/ux design");
        SKILL_ALIASES.put("ui", "ui/ux design");
        SKILL_ALIASES.put("ux", "ui/ux design");
    }

    /**
     * Calculates the match percentage (0 - 100) between a seeker's skills and a job's required skills.
     *
     * @param seekerSkillsStr Comma/semicolon/slash separated skills of the seeker
     * @param jobSkillsStr    Comma/semicolon/slash separated skills of the job
     * @return match percentage integer between 0 and 100
     */
    public int calculateMatchScore(String seekerSkillsStr, String jobSkillsStr) {
        if (seekerSkillsStr == null || jobSkillsStr == null) {
            return 0;
        }

        Set<String> seekerSkills = normalizeSkills(seekerSkillsStr);
        Set<String> jobSkills = normalizeSkills(jobSkillsStr);

        if (seekerSkills.isEmpty() || jobSkills.isEmpty()) {
            return 0;
        }

        int matchedCount = 0;
        for (String reqSkill : jobSkills) {
            boolean matched = false;
            for (String userSkill : seekerSkills) {
                if (userSkill.equalsIgnoreCase(reqSkill)) {
                    matched = true;
                    break;
                }
            }
            if (matched) {
                matchedCount++;
            }
        }

        // Percentage based on how many required job skills the seeker possesses
        double ratio = (double) matchedCount / jobSkills.size();
        return (int) Math.round(ratio * 100.0);
    }

    /**
     * Ranks a list of jobs based on the seeker's skills and attaches match scores.
     *
     * @param seekerProfile Seeker profile with skills
     * @param allJobs       List of active jobs to score and rank
     * @return Sorted list of jobs with matchScore set, highest match first
     */
    public List<Job> getRecommendedJobs(JobSeekerProfile seekerProfile, List<Job> allJobs) {
        if (seekerProfile == null || seekerProfile.getSkills() == null || allJobs == null || allJobs.isEmpty()) {
            return Collections.emptyList();
        }

        String seekerSkills = seekerProfile.getSkills();
        List<Job> scoredJobs = new ArrayList<>();

        for (Job job : allJobs) {
            int score = calculateMatchScore(seekerSkills, job.getSkillsRequired());
            job.setMatchScore(score);
            if (score > 0) {
                scoredJobs.add(job);
            }
        }

        // Sort descending by match score, then by newest creation date
        scoredJobs.sort((a, b) -> {
            int cmp = Integer.compare(b.getMatchScore(), a.getMatchScore());
            if (cmp != 0) return cmp;
            return b.getCreatedAt() != null && a.getCreatedAt() != null ?
                    b.getCreatedAt().compareTo(a.getCreatedAt()) : 0;
        });

        return scoredJobs;
    }

    private Set<String> normalizeSkills(String skillsStr) {
        if (skillsStr == null) return Collections.emptySet();
        return Arrays.stream(skillsStr.split("[,;\\|\\/]"))
                .map(String::trim)
                .map(String::toLowerCase)
                .filter(s -> !s.isEmpty())
                .map(s -> SKILL_ALIASES.getOrDefault(s, s))
                .collect(Collectors.toSet());
    }
}
