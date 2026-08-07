; styled styles.`css`
;; extends

;; vim: expandtab

(decorator
  (call_expression
    arguments: 
      (arguments
        (object
          (pair
            key: (property_identifier) @foo
            value:
                     (template_string
                       (string_fragment) @injection.content 
                       (#match? @foo "styles") (#set! injection.language "css")) @template)))))
