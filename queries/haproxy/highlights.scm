; Parser: https://github.com/thochra/tree-sitter-haproxy (registered in init.lua).
; Adapted from https://github.com/thochra/zed-haproxy-extension highlights.scm.

(comment) @comment @spell

; Sections
[
  "global"
  "defaults"
  "frontend"
  "backend"
  "listen"
  "resolvers"
  "userlist"
  "peers"
  "mailers"
  "cache"
  "program"
  "ring"
] @keyword

(section_name) @module

; Directives
(bind_directive "bind" @keyword)
(server_directive "server" @keyword)
(acl_directive "acl" @keyword)
(use_backend_directive "use_backend" @keyword)
(use_server_directive "use-server" @keyword)
(default_backend_directive "default_backend" @keyword)
(mode_directive "mode" @keyword)
(balance_directive "balance" @keyword)
(timeout_directive "timeout" @keyword)
(option_directive "option" @keyword)
(no_option_directive "no" @keyword "option" @keyword)
(log_directive "log" @keyword)
(maxconn_directive "maxconn" @keyword)
(nbproc_directive "nbproc" @keyword)
(nbthread_directive "nbthread" @keyword)
(cpu_map_directive "cpu-map" @keyword)
(tune_directive "tune" @keyword)
(stats_directive "stats" @keyword)
(daemon_directive) @keyword
(ca_base_directive "ca-base" @keyword)
(chroot_directive "chroot" @keyword)
(crt_base_directive "crt-base" @keyword)
(description_directive "description" @keyword)
(node_directive "node" @keyword)
(pidfile_directive "pidfile" @keyword)
(uid_directive "uid" @keyword)
(gid_directive "gid" @keyword)
(user_directive "user" @keyword)
(group_directive "group" @keyword)
(retries_directive "retries" @keyword)
(hash_type_directive "hash-type" @keyword)
(errorfile_directive "errorfile" @keyword)
(http_request_directive "http-request" @keyword)
(http_response_directive "http-response" @keyword)
(tcp_request_directive "tcp-request" @keyword)
(redirect_directive "redirect" @keyword)
(capture_directive "capture" @keyword)
(stick_directive "stick" @keyword)
(cookie_directive "cookie" @keyword)
(http_check_directive "http-check" @keyword)
(tcp_check_directive "tcp-check" @keyword)
(nameserver_directive "nameserver" @keyword)
(resolve_retries_directive "resolve_retries" @keyword)
(peer_directive "peer" @keyword)
(mailer_directive "mailer" @keyword)
(total_max_size_directive "total-max-size" @keyword)
(max_age_directive "max-age" @keyword)
(max_object_size_directive "max-object-size" @keyword)
(command_directive "command" @keyword)
(format_directive "format" @keyword)
(maxlen_directive "maxlen" @keyword)
(size_directive "size" @keyword)

(generic_directive
  (directive_name) @keyword)

; .if / .elif / .else / .endif / .notice ...
(generic_directive
  (directive_name) @keyword.directive
  (#lua-match? @keyword.directive "^%."))

; Conditions
(condition
  [
    "if"
    "unless"
  ] @keyword.conditional)

; Actions and names
(http_action) @function
(tcp_action) @function
(check_action) @function

(server_name) @variable.member
(acl_name) @label
(backend_ref) @module
(cookie_name) @variable
(identifier) @variable

(bind_address) @string.special
(server_address) @string.special
(address) @string.special

(number) @number
(size) @number
(time_value) @number
(http_status) @number

(path) @string.special.path
(string) @string

; Enums
[
  (log_level)
  (log_facility)
  (balance_algorithm)
  (hash_algorithm)
  (mode_type)
  (timeout_type)
  (tcp_type)
  (capture_type)
  (format_type)
] @constant

(option_name) @property
