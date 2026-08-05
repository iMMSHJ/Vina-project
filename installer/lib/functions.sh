#!/usr/bin/env bash


info()
{
    echo -e "${BLUE}[INFO]${NC} $1"
}


success()
{
    echo -e "${GREEN}[OK]${NC} $1"
}


warning()
{
    echo -e "${YELLOW}[WARN]${NC} $1"
}


error()
{
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}


command_exists()
{
    command -v "$1" >/dev/null 2>&1
}
