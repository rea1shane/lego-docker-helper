package docker

import (
	"bytes"
	"context"
	"fmt"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/stdcopy"
)

func exec(ctx context.Context, cli *client.Client, containerID string, cmd []string) (stdout, stderr string, err error) {
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
