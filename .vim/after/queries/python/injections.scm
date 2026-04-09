;; extends
(assignment
  left: (identifier) @identifier
  right: (string 
	  (string_content) @injection.content
	  (#match? @identifier "query|QUERY"))
  (#set! injection.language "sql"))

(string 
    (string_content) @injection.content
      (#vim-match? @injection.content "^\w*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
      (#set! injection.language "sql"))
