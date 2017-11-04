package com.fudan.cubemix.configuration;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.SDKGlobalConfiguration;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.ibm.oauth.BasicIBMOAuthCredentials;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @package com.fudan.cubemix.configuration
 * @Author Novemser
 * @Date 2017/11/4
 * <p>
 * Crafting with devotion.
 */
@Configuration
public class S3ClientConfiguration {

    static {
        SDKGlobalConfiguration.IAM_ENDPOINT = "https://iam.bluemix.net/oidc/token";
    }

    private final String bucketName = "novemser";
    private final String api_key = "4GB6RZSn4YnCd9oANgvkLaJenkbhx4JxOX6FubEKucGm";
    private final String service_instance_id = "crn:v1:bluemix:public:cloud-object-storage:global:a/6b9356a9cf1bc49b2f7ea2014a764e29:d1bfd0b6-b969-4e3e-8213-900b38abba40::";
    private final String endpoint_url = "https://s3-api.us-geo.objectstorage.softlayer.net";
    private final String location = "us";

    @Bean
    public AmazonS3 amazonS3() {
        return createClient(api_key, service_instance_id, endpoint_url, location);
    }

    private AmazonS3 createClient(String api_key, String service_instance_id, String endpoint_url, String location) {
        AWSCredentials credentials;
        if (endpoint_url.contains("objectstorage.softlayer.net")) {
            credentials = new BasicIBMOAuthCredentials(api_key, service_instance_id);
        } else {
            credentials = new BasicAWSCredentials(api_key, service_instance_id);
        }

        ClientConfiguration clientConfig = new ClientConfiguration().withRequestTimeout(5000);
        clientConfig.setUseTcpKeepAlive(true);

        return AmazonS3ClientBuilder
                .standard()
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endpoint_url, location))
                .withPathStyleAccessEnabled(true)
                .withClientConfiguration(clientConfig)
                .build();
    }
}
