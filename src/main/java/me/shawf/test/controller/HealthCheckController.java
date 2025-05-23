/*
 * Copyright (c) 2024-2024. All rights reserved.
 */

package me.shawf.test.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 健康见擦
 *
 * @author shawf
 * @since 2024-12-08
 */
@RestController
public class HealthCheckController {
    /**
     * 健康检查接口
     *
     * @return OK
     */
    @GetMapping("/healthcheck")
    public String healthcheck() {
        return "OK123123";
    }
}
