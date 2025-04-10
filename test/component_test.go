package test

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/firehose"
	"github.com/cloudposse/test-helpers/pkg/atmos"
	helper "github.com/cloudposse/test-helpers/pkg/atmos/component-helper"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type ComponentSuite struct {
	helper.TestSuite
}

func (s *ComponentSuite) TestBasic() {
	const component = "kinesis-firehose-stream/basic"
	const stack = "default-test"
	const awsRegion = "us-east-2"

	defer s.DestroyAtmosComponent(s.T(), component, stack, nil)
	options, _ := s.DeployAtmosComponent(s.T(), component, stack, nil)
	assert.NotNil(s.T(), options)

	// Get the Firehose stream name from outputs
	firehoseName := atmos.Output(s.T(), options, "kinesis_firehose_stream_name")
	require.NotEmpty(s.T(), firehoseName)

	// Load AWS configuration
	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(awsRegion))
	require.NoError(s.T(), err)

	// Create AWS Firehose client
	firehoseClient := firehose.NewFromConfig(cfg)

	// Get the Firehose stream details
	output, err := firehoseClient.DescribeDeliveryStream(context.Background(), &firehose.DescribeDeliveryStreamInput{
		DeliveryStreamName: &firehoseName,
	})
	require.NoError(s.T(), err)
	require.NotNil(s.T(), output)
	require.NotNil(s.T(), output.DeliveryStreamDescription)

	// Validate the Firehose stream configuration
	assert.Equal(s.T(), "ACTIVE", string(output.DeliveryStreamDescription.DeliveryStreamStatus))
	assert.Equal(s.T(), "DirectPut", string(output.DeliveryStreamDescription.DeliveryStreamType))

	s.DriftTest(component, stack, nil)
}

func (s *ComponentSuite) TestEnabledFlag() {
	const component = "kinesis-firehose-stream/disabled"
	const stack = "default-test"
	s.VerifyEnabledFlag(component, stack, nil)
}

func TestRunSuite(t *testing.T) {
	suite := new(ComponentSuite)
	// Add dependencies
	suite.AddDependency(t, "s3-bucket/cloudwatch", "default-test", nil)
	helper.Run(t, suite)
}
