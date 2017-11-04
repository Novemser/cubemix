package com.fudan.cubemix.controller;

import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.fudan.cubemix.model.MessageModel;
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

    @GetMapping("/listBucket")
    public List<Bucket> listNamespace() {
        return objStorageService.listBuckets();
    }

    //createText {bucketName} {text}
    @RequestMapping(value = "/createText/{bucketName}/{text}", method = RequestMethod.POST)
    public Object createText(@PathVariable String bucketName, @PathVariable String text) {

        return objStorageService.uploadTextTest(bucketName, text);

    }


    //List objects
    @GetMapping("/listObject/{namespace}")
    public List<S3ObjectSummary> listObject(@PathVariable String namespace) {
        return objStorageService.listObjectSummary(namespace);
    }

    @PostMapping("/createBucket/{name}")
    public Bucket createBucket(@PathVariable String name) {
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


    //Delete object
    @RequestMapping(value = "/destroyObject/{bucketName}/{name}", method = RequestMethod.DELETE)
    public Boolean deleteObject(@PathVariable String bucketName, @PathVariable String name) {
        return objStorageService.deleteobject(name, bucketName);
    }


    //Delete object
    @RequestMapping(value = "/destroyBucket/{bucketName}", method = RequestMethod.DELETE)
    public Boolean destroyBucket(@PathVariable String bucketName) {
        return objStorageService.deleteBucket(bucketName);
    }


    //    servlet
    @RequestMapping(value = "/servlet", method = RequestMethod.POST, produces = {"application/json"})
    public Object DeleteObject(@RequestBody MessageModel m) {
        return m;
    }

}
