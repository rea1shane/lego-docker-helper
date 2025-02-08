package action

import (
	"context"

	"github.com/docker/docker/client"

	"github.com/rea1shane/lego-docker-helper/docker"
)

type Restart struct {
	name        string
	containerID string
}

func (r *Restart) Name() string {
	return r.name
}

func (r *Restart) Execute(ctx context.Context, cli *client.Client) error {
	return docker.RestartContainer(ctx, cli, r.containerID)
}
