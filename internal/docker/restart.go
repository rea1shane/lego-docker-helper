package docker

import (
	"context"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
)

func RestartContainer(ctx context.Context, cli *client.Client, containerID string) error {
	return cli.ContainerRestart(ctx, containerID, container.StopOptions{})
}
