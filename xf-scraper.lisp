(defpackage :xf-scraper
  (:use :cl)
  (:export :main))

(in-package :xf-scraper)

(defmacro with-page-body (url &rest body)
  (let ((request (gensym)))
    `(let* ((,request (dex:get ,url)) (page-body (lquery:$ (initialize ,request))))
       ,@body)))

(defun remove-whitespace (str)
  (string-trim '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout) str))

(defun make-post (author post)
  (let ((post-author author)
	(post-content (remove-whitespace post)))
    (values
     (lambda () (format nil "User: ~A~%~%~A~%----------~%" post-author post-content))
     (lambda () post-author)
     (lambda () post-content))))

(defmacro with-posts (pb &rest body)
  `(let ((posts (map 'list #'(lambda (a p) (make-post a p)) ;;creating post list
		     (remove-if #'null (lquery:$ ,pb "article" (attr :data-author))) ;;getting author list
		     (map 'list #'(lambda (p) (elt (lquery:$ (inline (concatenate 'string "#" p)) "article" (text)) 0)) ;;getting post content list
			  (remove-if #'null (lquery:$ ,pb "article" (attr :id))))))) ;;getting post id list
     ,@body))

(defun main ()
  (let ((url (car (uiop:command-line-arguments))))
    (if url
	(with-page-body url
	  (with-posts page-body
	    (mapc #'(lambda (p) (princ (funcall p))) posts)))
	(format t "~A needs first argument to be an url.~%" (uiop:argv0)))))
