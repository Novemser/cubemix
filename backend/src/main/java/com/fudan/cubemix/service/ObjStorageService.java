package com.fudan.cubemix.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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


    @Autowired
    public ObjStorageService(AmazonS3 amazonS3) {
        this.amazonS3 = amazonS3;
    }

    List<Bucket> listBuckets() {
        return amazonS3.listBuckets();
    }

    List<S3ObjectSummary> listObjSummary(String bucketName) {
        return amazonS3.listObjects(new ListObjectsRequest().withBucketName(bucketName)).getObjectSummaries();
    }
}
