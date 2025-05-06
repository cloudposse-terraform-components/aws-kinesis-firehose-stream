---
tags:
  - terraform
  - terraform-modules
  - aws
  - components
  - terraform-components
  - kinesis
  - firehose
  - cloudwatch
  - s3
  - monitoring
  - logging
  - eks
---

# Component: `firehose-stream`

This component provisions a Kinesis Firehose delivery stream and at this time supports CloudWatch to S3 delivery. It enables you to stream logs from EKS CloudWatch to an S3 bucket for long-term storage and analysis.
## Usage

**Stack Level**: Regional

Here's an example of how to set up a Firehose stream to capture EKS CloudWatch logs and deliver them to an S3 bucket:

```yaml
components:
  terraform:
    # First, ensure you have the required dependencies:
    eks/cluster:
      vars:
        name: eks-cluster
        # ... other EKS cluster configuration

    eks/cloudwatch:
      vars:
        name: eks-cloudwatch
        # ... other CloudWatch configuration

    s3-bucket/cloudwatch:
      vars:
        name: cloudwatch-logs-bucket
        # ... other S3 bucket configuration

    # Then configure the Firehose stream:
    kinesis-firehose-stream/basic:
      metadata:
        component: kinesis-firehose-stream
      vars:
        name: cloudwatch-logs
        # Source CloudWatch component name
        source_cloudwatch_component_name: eks/cloudwatch
        # Destination S3 bucket component name
        destination_bucket_component_name: s3-bucket/cloudwatch
        # Optional: Enable encryption for the Firehose stream
        encryption_enabled: true
```

This configuration will:
1. Create a Kinesis Firehose delivery stream
2. Configure it to receive logs from the specified EKS CloudWatch component
3. Deliver the logs to the specified S3 bucket
4. Optionally enable encryption for the stream


## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (>= 4.0)

## Modules

The following Modules are called:

### <a name="module_cloudwatch"></a> [cloudwatch](#module\_cloudwatch)

Source: cloudposse/stack-config/yaml//modules/remote-state

Version: 1.8.0

### <a name="module_cloudwatch_subscription_role"></a> [cloudwatch\_subscription\_role](#module\_cloudwatch\_subscription\_role)

Source: cloudposse/iam-role/aws

Version: 0.20.0

### <a name="module_firehose_role"></a> [firehose\_role](#module\_firehose\_role)

Source: cloudposse/iam-role/aws

Version: 0.20.0

### <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles)

Source: ../account-map/modules/iam-roles

Version:

### <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket)

Source: cloudposse/stack-config/yaml//modules/remote-state

Version: 1.8.0

### <a name="module_stream_label"></a> [stream\_label](#module\_stream\_label)

Source: cloudposse/label/null

Version: 0.25.0

### <a name="module_this"></a> [this](#module\_this)

Source: cloudposse/label/null

Version: 0.25.0

## Resources

The following resources are used by this module:

- [aws_cloudwatch_log_subscription_filter.firehose_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) (resource)
- [aws_kinesis_firehose_delivery_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) (resource)
- [aws_iam_policy_document.cloudwatch_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_iam_policy_document.firehose_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_kms_alias.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_region"></a> [region](#input\_region)

Description: AWS Region 2

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map)

Description: Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.  
This is for some rare cases where resources want additional configuration of tags  
and therefore take a list of maps with tag key, value, and additional configuration.

Type: `map(string)`

Default: `{}`

### <a name="input_attributes"></a> [attributes](#input\_attributes)

Description: ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,  
in the order they appear in the list. New attributes are appended to the  
end of the list. The elements of the list are joined by the `delimiter`  
and treated as a single ID element.

Type: `list(string)`

Default: `[]`

### <a name="input_context"></a> [context](#input\_context)

Description: Single object for setting entire context at once.  
See description of individual variables for details.  
Leave string and numeric variables as `null` to use default value.  
Individual variable settings (non-null) override settings in context object,  
except for attributes, tags, and additional\_tag\_map, which are merged.

Type: `any`

Default:

```json
{
  "additional_tag_map": {},
  "attributes": [],
  "delimiter": null,
  "descriptor_formats": {},
  "enabled": true,
  "environment": null,
  "id_length_limit": null,
  "label_key_case": null,
  "label_order": [],
  "label_value_case": null,
  "labels_as_tags": [
    "unset"
  ],
  "name": null,
  "namespace": null,
  "regex_replace_chars": null,
  "stage": null,
  "tags": {},
  "tenant": null
}
```

### <a name="input_delimiter"></a> [delimiter](#input\_delimiter)

Description: Delimiter to be used between ID elements.  
Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.

Type: `string`

Default: `null`

### <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats)

Description: Describe additional descriptors to be output in the `descriptors` output map.  
Map of maps. Keys are names of descriptors. Values are maps of the form
`{  
   format = string  
   labels = list(string)
}`
(Type is `any` so the map values can later be enhanced to provide additional options.)
`format` is a Terraform format string to be passed to the `format()` function.
`labels` is a list of labels, in order, to pass to `format()` function.  
Label values will be normalized before being passed to `format()` so they will be  
identical to how they appear in `id`.  
Default is `{}` (`descriptors` output will be empty).

Type: `any`

Default: `{}`

### <a name="input_destination_bucket_component_name"></a> [destination\_bucket\_component\_name](#input\_destination\_bucket\_component\_name)

Description: The name of the component that will be using the destination bucket

Type: `string`

Default: `"s3-bucket/cloudwatch"`

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Set to false to prevent the module from creating any resources

Type: `bool`

Default: `null`

### <a name="input_encryption_enabled"></a> [encryption\_enabled](#input\_encryption\_enabled)

Description: Enable encryption for the Kinesis Firehose Delivery Stream

Type: `bool`

Default: `true`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'

Type: `string`

Default: `null`

### <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit)

Description: Limit `id` to this many characters (minimum 6).  
Set to `0` for unlimited length.  
Set to `null` for keep the existing setting, which defaults to `0`.  
Does not affect `id_full`.

Type: `number`

Default: `null`

### <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case)

Description: Controls the letter case of the `tags` keys (label names) for tags generated by this module.  
Does not affect keys of tags passed in via the `tags` input.  
Possible values: `lower`, `title`, `upper`.  
Default value: `title`.

Type: `string`

Default: `null`

### <a name="input_label_order"></a> [label\_order](#input\_label\_order)

Description: The order in which the labels (ID elements) appear in the `id`.  
Defaults to ["namespace", "environment", "stage", "name", "attributes"].  
You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.

Type: `list(string)`

Default: `null`

### <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case)

Description: Controls the letter case of ID elements (labels) as included in `id`,  
set as tag values, and output by this module individually.  
Does not affect values of tags passed in via the `tags` input.  
Possible values: `lower`, `title`, `upper` and `none` (no transformation).  
Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.  
Default value: `lower`.

Type: `string`

Default: `null`

### <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags)

Description: Set of labels (ID elements) to include as tags in the `tags` output.  
Default is to include all labels.  
Tags with empty values will not be included in the `tags` output.  
Set to `[]` to suppress all generated tags.
**Notes:**  
  The value of the `name` tag, if included, will be the `id`, not the `name`.  
  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be  
  changed in later chained modules. Attempts to change it will be silently ignored.

Type: `set(string)`

Default:

```json
[
  "default"
]
```

### <a name="input_name"></a> [name](#input\_name)

Description: ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.  
This is the only ID element not also included as a `tag`.  
The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.

Type: `string`

Default: `null`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique

Type: `string`

Default: `null`

### <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars)

Description: Terraform regular expression (regex) string.  
Characters matching the regex will be removed from the ID elements.  
If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits.

Type: `string`

Default: `null`

### <a name="input_source_cloudwatch_component_name"></a> [source\_cloudwatch\_component\_name](#input\_source\_cloudwatch\_component\_name)

Description: The name of the component that will be using the source cloudwatch

Type: `string`

Default: `"eks/cloudwatch"`

### <a name="input_stage"></a> [stage](#input\_stage)

Description: ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).  
Neither the tag keys nor the tag values will be modified by this module.

Type: `map(string)`

Default: `{}`

### <a name="input_tenant"></a> [tenant](#input\_tenant)

Description: ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_kinesis_firehose_stream_arn"></a> [kinesis\_firehose\_stream\_arn](#output\_kinesis\_firehose\_stream\_arn)

Description: The ARN of the Kinesis Firehose stream

### <a name="output_kinesis_firehose_stream_id"></a> [kinesis\_firehose\_stream\_id](#output\_kinesis\_firehose\_stream\_id)

Description: The ID of the Kinesis Firehose stream

### <a name="output_kinesis_firehose_stream_name"></a> [kinesis\_firehose\_stream\_name](#output\_kinesis\_firehose\_stream\_name)

Description: The name of the Kinesis Firehose stream


[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse-terraform-components/aws-kinesis-firehose-stream&utm_content=)
