package docker

import (
	"context"
	"fmt"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
)

func restart(ctx context.Context, cli *client.Client, containerID string) error {
	err := cli.ContainerRestart(ctx, containerID, container.StopOptions{})
	if err != nil {
		return fmt.Errorf("failed to restart container: %v", err)
	}
	return nil
}
