#!/bin/bash
# 云端实弹日志分析: usage: analyze-log.sh <logfile>
L="$1"
echo "===== ① agent 执行的 GIT_DIR/git diff 命令 ====="
grep -aoE "tool.execution_start: bash[^\"]*" "$L" | grep -E "GIT_DIR|git diff|fixtures" | head -10
echo
echo "===== ② external diff / validate-fixture 调用痕迹 ====="
grep -anE "validate-fixture|external diff|no-ext-diff" "$L" | head -8
echo
echo "===== ③ GIT_CONFIG 注入痕迹(云端是否有 45033 补丁) ====="
grep -aoE "GIT_CONFIG[A-Z_0-9]*(=[^ ]*)?" "$L" | sort | uniq -c
echo
echo "===== ④ poc-evidence / payload 写入痕迹 ====="
grep -anE "poc-evidence|CLOUD-POC|fx-cache" "$L" | head -5
echo
echo "===== ⑤ 权限/审批事件 ====="
grep -acE "permission.requested" "$L" | xargs echo "permission.requested 次数:"
grep -aoE "all tool calls auto-approved|permission gate.{0,50}" "$L" | head -3
