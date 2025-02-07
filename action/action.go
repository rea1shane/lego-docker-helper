package action

import (
	"context"

	"github.com/docker/docker/client"
)

type Action interface {
	Name() string
	Execute(ctx context.Context, cli *client.Client) error
}
