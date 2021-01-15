(defpackage :xf-scraper
  (:use :cl)
  (:export :main))

(in-package :xf-scraper)

(declaim (inline remove-whitespace print-page))

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

(defun get-posts (page)
  "Get a list of posts."
  (map 'list #'make-post ;;creating post list
       (remove-if #'null (lquery:$ page "article" (attr :data-author))) ;;getting author list
       (map 'list #'(lambda (p) (elt (lquery:$ (inline (concatenate 'string "#" p)) "article" (text)) 0)) ;;getting post content list
	    (remove-if #'null (lquery:$ page "article" (attr :id)))))) ;;getting post id list

(defun print-page (page)
  "Print each post from a page."
  (dolist (post page)
    (princ (funcall post))))

(defmacro with-page-check ((url) &body body)
  "Wraps the with-posts macro in a conditional which checks if a url is given while also storing the url in a symbol called 'link."
  `(let ((link ,url))
     (if link
	 (progn
	   ,@body)
	 (format t "~A needs first argument to be an url.~%" (uiop:argv0)))))
  
(defun main ()
  (with-page-check ((car (uiop:command-line-arguments)))
    (print-page (get-posts (get-page link)))))
