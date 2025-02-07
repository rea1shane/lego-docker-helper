package docker

import (
	"bytes"
	"context"
	"fmt"
	"os"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/stdcopy"
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

func CopyToContainer(ctx context.Context, cli *client.Client, containerID, destinationPath, sourcePath string) error {
	sourceFile, err := os.Open(sourcePath)
	if err != nil {
		return fmt.Errorf("failed to open source file: %v", err)
	}
	defer sourceFile.Close()

	return cli.CopyToContainer(ctx, containerID, destinationPath, sourceFile, container.CopyToContainerOptions{
		AllowOverwriteDirWithFile: true,
		CopyUIDGID:                true,
	})
}

func ExecuteInContainer(ctx context.Context, cli *client.Client, containerID string, cmd []string) (stdout, stderr string, err error) {
	config := container.ExecOptions{
		Cmd:          cmd,
		AttachStdout: true,
		AttachStderr: true,
	}

	id, err := cli.ContainerExecCreate(ctx, containerID, config)
	if err != nil {
		return "", "", fmt.Errorf("failed to create exec: %v", err)
	}

	response, err := cli.ContainerExecAttach(ctx, id.ID, container.ExecAttachOptions{})
	if err != nil {
		return "", "", fmt.Errorf("failed to attach to exec: %v", err)
	}
	defer response.Close()

	var stdoutBuffer, stderrBuffer bytes.Buffer
	_, err = stdcopy.StdCopy(&stdoutBuffer, &stderrBuffer, response.Reader)
	if err != nil {
		return "", "", fmt.Errorf("failed to read exec output: %v", err)
	}

	inspect, err := cli.ContainerExecInspect(ctx, id.ID)
	if err != nil {
		return "", "", fmt.Errorf("failed to inspect exec: %v", err)
	}

	if inspect.ExitCode != 0 {
		err = fmt.Errorf("command exited with code %d", inspect.ExitCode)
	}
	stdout = stdoutBuffer.String()
	stderr = stderrBuffer.String()
	return
}

func RestartContainer(ctx context.Context, cli *client.Client, containerID string) error {
	return cli.ContainerRestart(ctx, containerID, container.StopOptions{})
}
