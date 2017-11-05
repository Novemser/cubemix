package com.fudan.cubemix.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.amazonaws.util.StringInputStream;
import org.apache.commons.logging.impl.SLF4JLogFactory;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

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
        List<S3ObjectSummary> s3ObjectSummaryList = new ArrayList<>();
        try {
            s3ObjectSummaryList = amazonS3
                    .listObjects(new ListObjectsRequest().withBucketName(bucketName))
                    .getObjectSummaries();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s3ObjectSummaryList;
    }

    public Bucket createBucket(String name) {
        CreateBucketRequest createBucketRequest = new CreateBucketRequest(name);
        try {
            return amazonS3.createBucket(createBucketRequest);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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


    public com.alibaba.fastjson.JSONObject uploadTextTest(String bucket, String text) {
        try {
            InputStream is = new StringInputStream(text);
            ObjectMetadata metadata = new ObjectMetadata();
            com.alibaba.fastjson.JSONObject jsonObject = new com.alibaba.fastjson.JSONObject();
            jsonObject.put("creationDate", new Date().toString());
            jsonObject.put("storageClass", "STANDARD");
            metadata.setContentLength(text.length());
            String key = UUID.randomUUID().toString();
            jsonObject.put("key", key);
            jsonObject.put("size", text.length());
            PutObjectRequest request =
                    new PutObjectRequest(bucket, key, is, metadata);
            amazonS3.putObject(request);
            return jsonObject;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
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

    public Boolean deleteObject(String key, String bucket) {
        try {
            amazonS3.deleteObject( // delete the Object, passing…
                    bucket, // the name of the Bucket that stores the Object,
                    key // and he name of the Object to be deleted
            );
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Boolean deleteAllObjectInBucket(String bucketName) {
        List<S3ObjectSummary> s3ObjectSummaryList = listObjectSummary(bucketName);

        Boolean result = false;
        try {
            for (S3ObjectSummary s : s3ObjectSummaryList) {
                amazonS3.deleteObject(bucketName, s.getKey());
            }
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;


//        amazonS3.deleteObject(bucketName,"");
    }

    //deleteBucket(String bucketName)
    public Boolean deleteBucket(String bucketName) {
        Boolean result = false;

        Boolean conditionState = deleteAllObjectInBucket(bucketName);
        if (conditionState) {
            try {
                amazonS3.deleteBucket(bucketName);
                result = true;

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;

    }

}
