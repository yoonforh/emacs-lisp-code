;;; $Id$

;;;
;;; change pytorch math expressions for emacs latex preview
;;;
(defun replace-math1()
  "Replace math annotation regex with TeX block type 1"
  (interactive)
  (goto-char (point-min))
  (replace-regexp ":math:`\\(.*?\\)`" "\\\\[\\1\\\\]") ;; ? after * means non-greedy matching
  )

(defun replace-math2-block(search-pos)
  "Replace math annotation regex with TeX block type 2"
  (interactive)
  ;; (print search-pos)
  (goto-char search-pos)
  (let ( ;; local variables
        (start-pos (search-forward "math::"))
        (end-pos -1)
        (current-indent -1)
        (new-indent -1)
        (prev-line -1)
        (first-block-start -1)
        (line-start -1)
        ) ;; end of let local variables

    ;; start of let body
    (goto-char start-pos)
    ;; (print (concat "start-pos = " (number-to-string start-pos)))

    (if (>= start-pos 0)
        (progn
          
          (while (and (forward-line 1) (> current-indent -2))
            (progn
              (setq line-start (point))
              ;; (print (concat "line-start = " (number-to-string line-start)))
              (beginning-of-line-text)
              (setq block-start (point))
              ;; (print (concat "block-start = " (number-to-string block-start)))
              (if (< first-block-start 0)
                  (setq first-block-start block-start))
              (setq new-indent (- block-start line-start))
              ;; (print (concat "new-indent = " (number-to-string new-indent)))
              (if (>= new-indent current-indent)
                  (progn
                    (if (= current-indent -1)
                        (setq current-indent new-indent)
                      )
                    ;; (print (concat "current-indent = " (number-to-string current-indent)))
                    ;; (python-nav-forward-statement)
                    (setq prev-line (point))
                    ;; (print (concat "prev-line = " (number-to-string prev-line)))
                    )
                (progn
                  ;; (print (concat "breaking... current-indent = " (number-to-string current-indent)))
                  (setq current-indent -2)
                  )
                )
              )
            )

          ;; (python-nav-end-of-block)
          ;;(setq end-pos (point))
          (if (> prev-line 0)
              (progn
                (goto-char start-pos)
                (beginning-of-line-text)
                (setq start-pos (point))
                (goto-char prev-line)
                (end-of-line 1)
                (setq end-pos (point))))
          
          ;; (setq end-pos prev-line-end)
          (goto-char end-pos)
          (insert "\\]")
          (goto-char first-block-start)
          (insert "\\[")
          (goto-char (+ end-pos 4))
          ;; (print (concat "current position = " (number-to-string (point))))
          ;; (print (concat "start-pos = " (number-to-string start-pos)))
          ;; (print (concat "line-start = " (number-to-string line-start)))
          ;; (print (concat "block-start = " (number-to-string block-start)))
          ;; (print (concat "first-block-start = " (number-to-string first-block-start)))
          ;; (print (concat "end-pos = " (number-to-string end-pos)))
          ))
    (+ end-pos 4)
    )
  )

(defun replace-math2()
  "Replace math annotation regex with TeX block type 2"
  (interactive)
  (goto-char (point-min))
  (let ((start-point (point))
        (current-point -1))
    (while (> start-point 0)
      (progn
        (setq current-point (replace-math2-block start-point))
        (if (<= current-point start-point)
            (setq start-point -1)
          (setq start-point current-point)
          )
        ))
    )
  )

(defun replace-math()
  "Replace math annotation regex with TeX block"
  (interactive)
  (replace-math1)
  (replace-math2)
  )


;;;
;;; java related functions
;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; replace-slf-logger - by yoonforh ;; (convert slf4j statements into java.util.logger statements)
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun replace-slf-logger()
  "Replace slf4j logger statements with java.util.logger statements"
  (interactive)
  (goto-char (point-min))
  (replace-string "import org.slf4j.Logger;" "import java.util.logging.*;")
  (goto-char (point-min))
  (replace-string "import org.slf4j.LoggerFactory;" "")
  (goto-char (point-min))
  (replace-string "LoggerFactory.getLogger(" "Logger.getLogger(")
  (goto-char (point-min))
  (replace-string "logger.isErrorEnabled()" "logger.isLoggable(Level.SEVERE)")
  (goto-char (point-min))
  (replace-regexp "logger.error(\\(.*\\), \\(.*\\))" "logger.log(Level.SEVERE, \\1, \\2)")
  (goto-char (point-min))
  (replace-regexp "logger.error(" "logger.severe(")
  (goto-char (point-min))
  (replace-string "logger.isWarnEnabled()" "logger.isLoggable(Level.WARNING)")
  (goto-char (point-min))
  (replace-regexp "logger.warn(\\(.*\\), \\(.*\\))" "logger.log(Level.WARNING, \\1, \\2)")
  (goto-char (point-min))
  (replace-regexp "logger.warn(" "logger.warning(")
  (goto-char (point-min))
  (replace-string "logger.isInfoEnabled()" "logger.isLoggable(Level.INFO)")
  (goto-char (point-min))
  (replace-regexp "logger.info(\\(.*\\), \\(.*\\))" "logger.log(Level.INFO, \\1, \\2)")
  (goto-char (point-min))
  (replace-string "logger.isTraceEnabled()" "logger.isLoggable(Level.FINE)")
  (goto-char (point-min))
  (replace-regexp "logger.trace(\\(.*\\), \\(.*\\))" "logger.log(Level.FINE, \\1, \\2)")
  (goto-char (point-min))
  (replace-regexp "logger.trace(" "logger.fine(")
  (goto-char (point-min))
  (replace-string "logger.isDebugEnabled()" "logger.isLoggable(Level.FINEST)")
  (goto-char (point-min))
  (replace-regexp "logger.debug(\\(.*\\), \\(.*\\))" "logger.log(Level.FINEST, \\1, \\2)")
  (goto-char (point-min))
  (replace-regexp "logger.debug(" "logger.finest(")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ToString Wizard - yoonforh edition ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom jdee-wiz-tostring-sort-variables nil
  "*Specifies whether or not to sort the list of variables in the
  generated method or list them in the order defined in the file."
  :group 'jdee-wiz
  :type 'boolean)

(defcustom jdee-wiz-tostring-stringbuffer-size "100"
  "*Specifies the initial size of the StringBuffer used to create the
  result for the toString(). It is best to set this to a value large
  enough for most of your work to prevent expansion of the
  StringBuffer at runtime. You can always change the value in the
  generated code to a smaller or larger one as needed."
  :group 'jdee-wiz-tostring
  :type 'string)

(defcustom jdee-wiz-tostring-variable-separator "\", \""
  "*Specifies the string between each variable to separate them.
  Examples: 2 spaces (the default), a comma and a space, newline, or a
  method call (as long as the return value is a String).

  Note: Remember this must result in a String in Java!"
  :group 'jdee-wiz-tostring
  :type 'string)

(defcustom jdee-wiz-tostring-static-members nil
  "If on (nonnil), `jdee-wiz-tostring' generates information of
 static members of the class in the current buffer."
  :group 'jdee-wiz
  :type 'boolean)

(defun jdee-wiz-tostring()
  "Generates a toString() method for tbe class at point. The method
returns a string comprising the values of the member variables defined
by the class. The string lists the variables in alphabetical
order if `jdee-wiz-tostring-sort-variables' is on. The string uses the
string specified by `jdee-wiz-tostring-variable-separator' to separate
the variables. The generated method uses a string buffer of the size
specified by `jdee-wiz-tostring-stringbuffer-size' to build the string."
  (interactive)
  (let* ((class-name
          (jdee-parse-get-unqualified-name
           (jdee-parse-get-class-at-point)))
         (variables
          (semantic-brute-find-tag-by-class
           'variable
           (jdee-wiz-get-class-parts
            class-name
            (semantic-brute-find-tag-by-class
             'type
             (semantic-bovinate-toplevel t)
             ))))
         (method
          (concat
           "/**\n"
           " * {@inheritDoc}\n"
           " */\n"
           "public String toString()"
           (if jdee-gen-k&r " {\n" "\n{\n")
           "return \"" class-name "(")))

    (setq variables (jdee-wiz-filter-variables-by-typemodifier variables))

    (if jdee-wiz-tostring-sort-variables
        (setq variables (semantic-sort-tokens-by-name-increasing variables)))

;;    (setq size (length variables))
    (setq comma-count 0)

    (while variables
      (let* ((var (car variables))
             (name (semantic-tag-name var)) ;;variable name
             (type (semantic-tag-type var)) ;;variable type i.e. boolean
             (staticp
              (member "static"
                      (semantic-tag-modifiers var))) ;;is it static
             (finalp
              (member "final"
                      (semantic-tag-modifiers var)))) ;;is it final

        (if
            ;;            (or (not staticp) jdee-wiz-tostring-static-members)
            (not staticp)
            (progn
              (setq method (concat method name " - \" + " name "\n+ \", "))
              (setq comma-count (+ comma-count 1)))
          ;; (progn ;; staticp
          ;;   (setq size (- size 1))
          ;;   (print "hello")
          ;;   (if (= (length variables) 1)
          ;;       (setq method ;; remove preceding ", "
          ;;             (concat (substring method 0 (- (length method) 2)) ")\";\n}\n"))
          ;;     )
          ;;   )
          )

        (setq variables (cdr variables))))
    (if (> comma-count 0)
        (setq method ;; remove preceding ", "
                      (concat (substring method 0 (- (length method) 2)) ")\";\n}\n"))
        (setq method
              (concat method ")\";\n}\n")))

    (insert method))

  (jdee-wiz-indent (point)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-constructor - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun jdee-wiz-constructor()
  "Generates a constructor() method for tbe class at point. The method
returns a string comprising the values of the member variables defined
by the class."
  (interactive)
  (let* ((class-name
          (jdee-parse-get-unqualified-name
           (jdee-parse-get-class-at-point)))
         (variables
          (semantic-brute-find-tag-by-class
           'variable
           (jdee-wiz-get-class-parts
            class-name
            (semantic-brute-find-tag-by-class
             'type
             (semantic-bovinate-toplevel t)
             ))))
         (method
          (concat
           "public " class-name "("))
         (body)
         )

    (setq variables (jdee-wiz-filter-variables-by-typemodifier variables))

    (if jdee-wiz-tostring-sort-variables
        (setq variables (semantic-sort-tokens-by-name-increasing variables)))

    (setq size (length variables))

    (while variables
      (let* ((var (car variables))
             (name (semantic-tag-name var)) ;;variable name
             (type (semantic-tag-type var)) ;;variable type i.e. boolean
             (staticp
              (member "static"
                      (semantic-tag-modifiers var))) ;;is it static
             (finalp
              (member "final"
                      (semantic-tag-modifiers var)))) ;;is it final

        (if
            ;;           (or (not staticp) jdee-wiz-tostring-static-members)
            (not staticp)
            (progn
              (if (> (length variables) 1)
                  (setq method (concat method type " " name ", "))
                (setq method
                      (concat method type " " name (if jdee-gen-k&r ") {\n" ")\n{\n")))
                )
              (setq body (concat body "this." name " = " name ";\n"))
              ))
        (if staticp (setq size (- size 1)))
        (if finalp (setq size (- size 1)))

        (setq variables (cdr variables))))
    (if (= size 0)
        (setq method
              (concat method (if jdee-gen-k&r ") {\n" ")\n{\n"))))
    (setq method
          (concat method body "}\n"))

    (insert method))

  (jdee-wiz-indent (point)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-log-method - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;###autoload
(defun jdee-wiz-log-method()
  "insert logger statement of a method or constructor"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let ((found (jdee-yoonforh-nonterminal-at-line)))
    (if (not found)
        (error "No tag found at point")
      (let* ((modifiers (semantic-tag-modifiers found))
            (type (semantic-tag-type found))
            (name (semantic-tag-name found))
            (arguments (semantic-tag-function-arguments found))
            (throws (semantic-tag-function-throws found))
        (string
  (concat
   "if (logger.isLoggable(Level.FINEST))"
   (if jdee-gen-k&r " {\n" "\n{\n")
   "logger.finest(\""
          name
          "(")))

        (setq size (length arguments))

        (while arguments
          (let* ((arg (car arguments))
                 (name (semantic-tag-name arg)) ;;argument name
                 (type (semantic-tag-type arg)) ;;argument type i.e. boolean
                 )

            (if (> (length arguments) 1)
                (setq string (concat string name " - \" + " name " + \", "))
              (setq string
                    (concat string name " - \" + " name " + \")\");\n}\n\n")))

            (setq arguments (cdr arguments))))
        (if (= size 0)
            (setq string
                  (concat string ")\");\n}\n\n")))
        (insert string)
        ))

    (jdee-wiz-indent (point))
    ))

(defun jdee-wiz-logp-method()
  "insert logger.logp call statement within a method or a constructor"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let ((found (jdee-yoonforh-nonterminal-at-line)))
    (if (not found)
        (error "No tag found at point")
      (let* ((class-name
              (jdee-parse-get-unqualified-name
               (jdee-parse-get-class-at-point)))
             (modifiers (semantic-tag-modifiers found))
             (type (semantic-tag-type found))
             (name (semantic-tag-name found))
             (arguments (semantic-tag-function-arguments found))
             (throws (semantic-tag-function-throws found))
             (string
              (concat
               "if (logger.isLoggable(Level.FINEST))"
               (if jdee-gen-k&r " {\n" "\n{\n")
               "logger.logp(Level.FINEST, \""
               class-name
               "\", null, \""
               name
               "(")))

        (setq size (length arguments))

        (while arguments
          (let* ((arg (car arguments))
                 (name (semantic-tag-name arg)) ;;argument name
                 (type (semantic-tag-type arg)) ;;argument type i.e. boolean
                 )

            (if (> (length arguments) 1)
                (setq string (concat string name " - \" + " name " + \", "))
              (setq string
                    (concat string name " - \" + " name " + \")\");\n}\n\n")))

            (setq arguments (cdr arguments))))
        (if (= size 0)
            (setq string
                  (concat string ")\");\n}\n\n")))
        (insert string)
        ))

    (jdee-wiz-indent (point))
    ))

(defun jdee-yoonforh-nonterminal-at-line ()
  "Search the bovine table for the tag at the current line."
  (save-excursion
    ;; Preserve current tags when the lexer fails (when there is an
    ;; unclosed block or an unterminated string for example).
    (let ((semantic-flex-unterminated-syntax-end-function
           #'(lambda (syntax &rest ignore)
               (throw 'jdee-yoonforh-flex-error syntax))))
      (catch 'jdee-yoonforh-flex-error
        (semantic-fetch-tags))))
  (save-excursion
    ;; Move the point to the first non-blank character found. Skip
    ;; spaces, tabs and newlines.
    (beginning-of-line)
    (forward-comment (point-max))
    (semantic-current-tag)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-logger-decl - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun jdee-wiz-logger-decl()
  "insert logger declaration statement of current class"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let* ((class-name
  (jdee-parse-get-unqualified-name
   (jdee-parse-get-class-at-point)))
        (package (jdee-wiz-get-package-name)))
    (progn
      (if (not package)
          (setq string (concat "private static Logger logger = Logger.getLogger(" class-name ".class.getName());\n\n"))
         (setq string (concat "private static final Logger logger = Logger.getLogger(\"" package "\");\n\n"))
;; (setq string (concat "private static Logger logger = Logger.getLogger(" class-name ".class.getPackage().getName());\n\n"))
        (insert string)
        (jdee-wiz-indent (point))
      )
    ))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-assign-args - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;###autoload
(defun jdee-wiz-assign-args()
  "insert assign statements for each args of a method or constructor"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let ((found (jdee-yoonforh-nonterminal-at-line)))
    (if (not found)
        (error "No tag found at point")
      (let* ((modifiers (semantic-tag-modifiers found))
            (type (semantic-tag-type found))
            (name (semantic-tag-name found))
            (arguments (semantic-tag-function-arguments found))
            (throws (semantic-tag-function-throws found)))
        (while arguments
          (let* ((arg (car arguments))
                 (name (semantic-tag-name arg)) ;;argument name
                 (type (semantic-tag-type arg)) ;;argument type i.e. boolean
                 )

            (insert (concat "this." name " = " name ";\n"))
            (setq arguments (cdr arguments))))
        ))

    (jdee-wiz-indent (point))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-serial-ver - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun jdee-wiz-serial-ver()
  "insert serialver statement of current class"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let* ((class-name
          (jdee-parse-eval-type-of
           (jdee-parse-get-class-at-point)))
         )
    (progn
      (setq serial-ver (jdee-jeval
                        (concat "print(\" private static final long serialVersionUID = \" + java.io.ObjectStreamClass.lookup(Class.forName(\""
                                class-name
                                "\")).getSerialVersionUID() + \"L;\\n\");")
                        ))
      (if (= 0 (length serial-ver))
          (error "Cannot get serial version value")
        (insert serial-ver))
      (jdee-wiz-indent (point))
      )
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; jdee-wiz-delegate-impl - by yoonforh ;;
;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;###autoload
(defun jdee-wiz-delegate-impl()
  "insert impl delegate statement of a method or constructor"
  (interactive)
  (if (not (eq major-mode 'jdee-mode))
      (error "Major mode must be 'jdee-mode'"))
  (let ((found (jdee-yoonforh-nonterminal-at-line)))
    (if (not found)
        (error "No tag found at point")
      (let* ((modifiers (semantic-tag-modifiers found))
             (method-type (semantic-tag-type found))
             (method-name (semantic-tag-name found))
             (arguments (semantic-tag-function-arguments found))
             (throws (semantic-tag-function-throws found))
             )
        (if (not (string= method-type "void"))
            (setq string (concat "return impl." method-name "("))
          (setq string (concat "impl." method-name "(")))

        (setq size (length arguments))

        (while arguments
          (let* ((arg (car arguments))
                 (name (semantic-tag-name arg)) ;;argument name
                 (type (semantic-tag-type arg)) ;;argument type i.e. boolean
                 )
            (if (> (length arguments) 1)
                (setq string (concat string name ", "))
              (setq string
                    (concat string name ");")))

            (setq arguments (cdr arguments))))
        (if (= size 0)
            (setq string
                  (concat string ");")))
        (insert string)
        ))

    (jdee-wiz-indent (point))
    ))

(global-set-key [?\C-c?\C-v?l] 'jdee-wiz-logp-method)
(global-set-key [?\C-c?\C-v?s] 'jdee-wiz-tostring)
(global-set-key [?\C-c?\C-v?a] 'jdee-wiz-assign-args)
(global-set-key [?\C-c?\C-v?c] 'jdee-wiz-constructor)
(global-set-key [?\C-c?\C-v?p] 'jdee-wiz-logger-decl)
(global-set-key [?\C-c?\C-v?d] 'jdee-wiz-delegate-impl)


;;; end of yoonforh.el
