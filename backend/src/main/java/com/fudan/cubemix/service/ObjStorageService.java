package com.fudan.cubemix.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import org.apache.commons.logging.impl.SLF4JLogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * @package com.fudan.cubemix.service
 * @Author Novemser
 * @Date 2017/11/4
 * <p>
 * Crafting with devotion.
 */

@Service
public class ObjStorageService {
    private final AmazonS3 amazonS3;
    private final Logger logger = LoggerFactory.getLogger(getClass().getName());
    private final String basePath = "img_repository\\";

    @Autowired
    public ObjStorageService(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    public List<Bucket> listBuckets() {
        return amazonS3.listBuckets();
    }

    public List<S3ObjectSummary> listObjectSummary(String bucketName) {
        return amazonS3
                .listObjects(new ListObjectsRequest().withBucketName(bucketName))
                .getObjectSummaries();
    }

    public Boolean createBucket(String name) {
        CreateBucketRequest createBucketRequest = new CreateBucketRequest(name);
        try {
            amazonS3.createBucket(createBucketRequest);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public Boolean uploadFileToBucket(String imageSource, String bucket) {

        try {
            imageSource += ".png";
            PutObjectRequest putObjectRequest = new PutObjectRequest(bucket, imageSource, new File(basePath + imageSource));
            amazonS3.putObject(putObjectRequest);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String downloadObject(String path, String bucket) {
        return basePath + path;
    }

    public String copyObject(String from, String to, String name, String newName) {

        try {
            amazonS3.copyObject( // copy the Object, passing…
                    from,  // the name of the Bucket in which the Object to be copied is stored,
                    name,  // the name of the Object being copied from the source Bucket,
                    to,  // the name of the Bucket in which the Object to be copied is stored,
                    newName   // and the new name of the copy of the Object to be copied
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newName;
    }

    public List<S3ObjectSummary> showAllObject(String bucket) {
        List<S3ObjectSummary> summaries = new ArrayList<>();
        try {
            ObjectListing listing = amazonS3.listObjects(bucket); // get the list of objects in the 'sample' bucket
            summaries = listing.getObjectSummaries(); // create a list of object summaries

        } catch (Exception e) {
            e.printStackTrace();
        }
        return summaries;
    }

    //Delete object

    public Boolean deleteobject(String key, String bucket) {
        Boolean result = false;
        try {
            amazonS3.deleteObject( // delete the Object, passing…
                    bucket, // the name of the Bucket that stores the Object,
                    key // and he name of the Object to be deleted
            );
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }


}
