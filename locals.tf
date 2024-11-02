locals {
  ssh-keys = "ubuntu:${file("/home/user/.ssh/id_ed25519.pub")}"
}
