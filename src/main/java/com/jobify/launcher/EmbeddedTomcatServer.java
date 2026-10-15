package com.jobify.launcher;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;
import java.util.logging.Logger;

/**
 * Embedded Apache Tomcat 10.1 Launcher for Jobify.
 * Enables zero-setup local execution for evaluations, college viva, and testing.
 * Can be run via: `mvn exec:java` or directly from IDE.
 */
public class EmbeddedTomcatServer {

    private static final Logger LOGGER = Logger.getLogger(EmbeddedTomcatServer.class.getName());
    private static final int DEFAULT_PORT = 8080;

    public static void main(String[] args) throws Exception {
        int port = DEFAULT_PORT;

        if (args != null && args.length > 0) {
            try {
                port = Integer.parseInt(args[0]);
            } catch (NumberFormatException ignored) {
            }
        } else {
            String envPort = System.getenv("PORT");
            if (envPort != null && !envPort.trim().isEmpty()) {
                try {
                    port = Integer.parseInt(envPort.trim());
                } catch (NumberFormatException ignored) {
                }
            }
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector(); // Triggers default HTTP connector initialization

        String webappDirLocation = "src/main/webapp";
        File webappDir = new File(webappDirLocation);
        if (!webappDir.exists()) {
            throw new IllegalStateException("Webapp directory not found at: " + webappDir.getAbsolutePath());
        }

        // Configure base working directory for Tomcat temp files
        String baseDir = new File("target/tomcat." + port).getAbsolutePath();
        tomcat.setBaseDir(baseDir);

        // Add web application context mounted at root context path
        Context ctx = tomcat.addWebapp("", webappDir.getAbsolutePath());
        ctx.setParentClassLoader(EmbeddedTomcatServer.class.getClassLoader());

        // Also mount at /jobify to support http://localhost:8080/jobify/...
        Context ctxJobify = tomcat.addWebapp("/jobify", webappDir.getAbsolutePath());
        ctxJobify.setParentClassLoader(EmbeddedTomcatServer.class.getClassLoader());

        // Attach compiled classes (target/classes) to the WebAppClassLoader resource root
        File additionWebInfClasses = new File("target/classes");
        if (additionWebInfClasses.exists()) {
            StandardRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(
                    resources,
                    "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(),
                    "/"
            ));
            ctx.setResources(resources);

            StandardRoot resourcesJobify = new StandardRoot(ctxJobify);
            resourcesJobify.addPreResources(new DirResourceSet(
                    resourcesJobify,
                    "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(),
                    "/"
            ));
            ctxJobify.setResources(resourcesJobify);
        }

        LOGGER.info("=================================================================");
        LOGGER.info(" Starting Jobify Portal on Embedded Apache Tomcat 10.1");
        LOGGER.info(" Root URL:    http://localhost:" + port + "/");
        LOGGER.info(" Context URL: http://localhost:" + port + "/jobify/");
        LOGGER.info(" WebApp Directory: " + webappDir.getAbsolutePath());
        LOGGER.info(" Base Directory:   " + baseDir);
        LOGGER.info("=================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
