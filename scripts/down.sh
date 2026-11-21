#!/usr/bin/env bash
pkill -f "port-forward.*microrred-bi" 2>/dev/null || true
kind delete cluster --name microrred
