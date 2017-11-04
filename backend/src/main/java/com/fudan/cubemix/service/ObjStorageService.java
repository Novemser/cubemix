package com.fudan.cubemix.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.Bucket;
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import org.apache.commons.logging.impl.SLF4JLogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    private final Logger logger = LoggerFactory.getLogger(getClass().getName());

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


}
