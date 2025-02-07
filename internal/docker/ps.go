package docker

import (
	"context"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
)

func ListContainers(ctx context.Context, cli *client.Client, all bool, labels ...string) ([]types.Container, error) {
	var labelArgs []filters.KeyValuePair
	for _, label := range labels {
		labelArgs = append(labelArgs, filters.Arg("label", label))
	}

	return cli.ContainerList(ctx, container.ListOptions{
		All:     all,
		Filters: filters.NewArgs(labelArgs...),
	})
}
