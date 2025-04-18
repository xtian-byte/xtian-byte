#!/bin/bash

# server-stats.sh - Basic Server Performance Stats

# Function to get total CPU usage
cpu_usage() {
  echo "=== CPU Usage ==="
  top -bn1 | grep "Cpu(s)" | \
    awk '{printf "CPU Usage: %.2f%%\n", 100 - $8}'
  echo
}

# Function to get memory usage
memory_usage() {
  echo "=== Memory Usage ==="
  free -m | awk 'NR==2{ \
    used=$3; \
    total=$2; \
    printf "Used: %d MB, Free: %d MB, Usage: %.2f%%\n", used, total-used, used/total * 100 \
  }'
  echo
}

# Function to get disk usage
disk_usage() {
  echo "=== Disk Usage ==="
  df -h --total | grep total | \
    awk '{printf "Used: %s, Free: %s, Usage: %s\n", $3, $4, $5}'
  echo
}

# Function to get top 5 processes by CPU usage
top_cpu_processes() {
  echo "=== Top 5 Processes by CPU Usage ==="
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
  echo
}

# Function to get top 5 processes by memory usage
top_mem_processes() {
  echo "=== Top 5 Processes by Memory Usage ==="
  ps -eo pid,comm,%mem --sort=-%mem | head -n 6
  echo
}

# Stretch Goal: OS version, uptime, load average, logged in users, failed login attempts
extra_stats() {
  echo "=== Extra System Info ==="
  echo "OS Version: $(lsb_release -d | cut -f2-)"
  echo "Uptime: $(uptime -p)"
  echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
  echo "Logged-in Users: $(who | wc -l)"
  echo "Failed Login Attempts (last 24h):"
  journalctl _COMM=sshd --since="24 hours ago" | grep "Failed password" | wc -l
  echo
}

# Run all functions
cpu_usage
memory_usage
disk_usage
top_cpu_processes
top_mem_processes
extra_stats
