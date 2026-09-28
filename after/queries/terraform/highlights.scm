; extends

; Additions on top of nvim-treesitter's hcl/terraform queries. Patterns here come
; later than the base ones, so they win on the same node.
; Labels capture the inner template_literal: the base query paints it @string,
; and a capture on the parent string_lit would stay underneath.

; resource "aws_instance" "web" / data "aws_ami" "ubuntu"
(config_file
  (body
    (block
      (identifier) @_kind
      .
      (string_lit
        (template_literal) @type)
      .
      (string_lit
        (template_literal) @string.special))
    (#any-of? @_kind "resource" "data" "ephemeral")))

; Block names use @string.special, not @label: many themes give @label the
; keyword color, so the name blends into "module"/"resource".

; module "vpc" / variable "x" / output "y" / provider "aws"
(config_file
  (body
    (block
      (identifier) @_kind
      .
      (string_lit
        (template_literal) @string.special) .
      (block_start))
    (#any-of? @_kind "module" "variable" "output" "provider" "check" "removed" "moved" "import")))

; aws_instance.web.id: the resource type is a type, not a builtin like var/local
(expression
  (variable_expr
    (identifier) @type
    (#lua-match? @type "_"))
  .
  (get_attr))

; data.aws_ami.ubuntu.id
(expression
  (variable_expr
    (identifier) @_data
    (#eq? @_data "data"))
  .
  (get_attr
    (identifier) @type))

; each.key / count.index / self.x
(expression
  (variable_expr
    (identifier) @variable.builtin
    (#any-of? @variable.builtin "each" "count" "self"))
  .
  (get_attr
    (identifier) @variable.builtin))

; Meta-arguments
(attribute
  (identifier) @keyword
  (#any-of? @keyword "count" "for_each" "depends_on" "provider" "providers"))

; Meta-blocks
(block
  (identifier) @keyword
  (#any-of? @keyword "lifecycle" "dynamic" "content" "provisioner" "connection"))

; module "x" { source = ... version = ... }
(block
  (identifier) @_kind
  (#eq? @_kind "module")
  (body
    (attribute
      (identifier) @keyword
      (#any-of? @keyword "source" "version"))))
