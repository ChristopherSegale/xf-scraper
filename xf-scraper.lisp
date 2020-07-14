(defpackage :xf-scraper
  (:use :cl)
  (:export :main))

(in-package :xf-scraper)

(declaim (inline get-page)
	 (inline remove-whitespace))

(defun get-page (url)
  "Get database which the posts are pulled from."
  (lquery:$ (initialize (dex:get url))))

(defun remove-whitespace (str)
  "Remove whitespace from beginning and end of string."
  (string-trim '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout) str))

(defun make-post (author post)
  "Returns a function which prints the contents of a post."
  (let ((post-author author)
	(post-content (remove-whitespace post)))
   (lambda ()
     (values
      (format nil "User: ~A~%~%~A~%----------~%" post-author post-content)
      post-author
      post-content))))

(defmacro with-gensyms (vars &body body)
  "Binds a list of variables with gensym values."
  `(let ,(mapcar #'(lambda (v) `(,v (gensym))) vars)
     ,@body))

(defmacro with-posts (pb &body body)
  "Anaphoric macro which automatically uses the 'posts symbol to hold a post list."
  (with-gensyms (page)
    `(let* ((,page ,pb)
	    (posts (map 'list #'make-post ;;creating post list
			(remove-if #'null (lquery:$ ,page "article" (attr :data-author))) ;;getting author list
			(map 'list #'(lambda (p) (elt (lquery:$ (inline (concatenate 'string "#" p)) "article" (text)) 0)) ;;getting post content list
			     (remove-if #'null (lquery:$ ,page "article" (attr :id))))))) ;;getting post id list
       ,@body)))

(defmacro check-page (url &body body)
  "Wraps the with-posts macro in a conditional which checks if a url is given"
  (with-gensyms (link)
    `(let ((,link ,url))
       (if ,link
	   (with-posts (get-page ,link)
	     ,@body)
       (format t "~A needs first argument to be an url.~%" (uiop:argv0))))))

(defun main ()
  (check-page (car (uiop:command-line-arguments))
    (mapc #'(lambda (p) (princ (funcall p))) posts)))
