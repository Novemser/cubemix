package com.fudan.cubemix.controller;

import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.fudan.cubemix.service.ObjStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    @PostMapping("/createBucket/{name}")
    public Object createBucket(@PathVariable String name) {
        return objStorageService.createBucket(name);
    }


    @RequestMapping(value = "/upload/{path}/{bucket}", method = RequestMethod.POST)
    public Object uploadFile(@PathVariable String path, @PathVariable String bucket) {
        return objStorageService.uploadFileToBucket(path, bucket);
    }

    @RequestMapping(value = "/download/{path}/{bucket}", method = RequestMethod.POST)
    public Object DownloadObject(@PathVariable String path, @PathVariable String bucket) {
        return objStorageService.downloadObject(path, bucket);
    }

    //Copy objects
    @RequestMapping(value = "/copy/{from}/{to}/{name}/{newName}", method = RequestMethod.POST)
    public Object CopyObject(@PathVariable String from, @PathVariable String to, @PathVariable String name, @PathVariable String newName) {
        return objStorageService.copyObject(from, to, name, newName);
    }

    //List objects
    @RequestMapping(value = "/{key}/{bucket}", method = RequestMethod.GET)
    public List<S3ObjectSummary> DeleteObject(@PathVariable String bucket) {
        return objStorageService.showAllObject(bucket);
    }

    //Delete object
    @RequestMapping(value = "/{key}/{bucket}", method = RequestMethod.DELETE)
    public Boolean ShowAllObject(@PathVariable String key, @PathVariable String bucket) {
        return objStorageService.deleteobject(key, bucket);
    }

}
