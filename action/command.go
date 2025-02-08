package action

import (
	"context"

	"github.com/docker/docker/client"

	"github.com/rea1shane/lego-docker-helper/docker"
)

type Command struct {
	name        string
	containerID string
	cmd         string
}

func (c *Command) Name() string {
	return c.name
}

func (c *Command) Execute(ctx context.Context, cli *client.Client) error {
	cmd := []string{"sh", "-c", c.cmd}
	stdout, stderr, err := docker.ExecuteInContainer(ctx, cli, c.containerID, cmd)
	_ = stdout
	_ = stderr
	return err
}
