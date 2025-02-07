package docker

import (
	"context"
	"fmt"
	"os"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
)

func cp(ctx context.Context, cli *client.Client, containerID, destinationPath, sourcePath string) error {
	sourceFile, err := os.Open(sourcePath)
	if err != nil {
		return fmt.Errorf("failed to open source file: %v", err)
	}
	defer sourceFile.Close()

	err = cli.CopyToContainer(ctx, containerID, destinationPath, sourceFile, container.CopyToContainerOptions{
		AllowOverwriteDirWithFile: true,
		CopyUIDGID:                true,
	})
	if err != nil {
		return fmt.Errorf("failed to copy to container: %v", err)
	}

	return nil
}
