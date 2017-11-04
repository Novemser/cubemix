package com.fudan.cubemix.controller;

import com.fudan.cubemix.service.ObjStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/**
 * @package com.fudan.cubemix.controller
 * @Author Novemser
 * @Date 2017/11/4
 * <p>
 * Crafting with devotion.
 */
@RestController
public class MainController {
    private final ObjStorageService objStorageService;

    @Autowired
    public MainController(ObjStorageService objStorageService) {
        this.objStorageService = objStorageService;
    }

    @GetMapping("/listNamespace")
    public Object listNamespace() {
        return objStorageService.listBuckets();
    }

    @GetMapping("/listObject/{namespace}")
    public Object listObject(@PathVariable String namespace) {
        return objStorageService.listObjectSummary(namespace);
    }
}
