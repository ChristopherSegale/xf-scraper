(defpackage :xf-scraper
  (:use :cl)
  (:export :main))

(in-package :xf-scraper)

(defun make-post (author post)
  (let ((post-author author)
	(post-content (string-trim '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout) post)))
    (values
     (lambda () (format nil "User: ~A~%~%~A~%----------~%" post-author post-content))
     (lambda () post-author)
     (lambda () post-content))))

(defun main ()
  (let ((url (cadr sb-ext:*posix-argv*)))
    (if url
	(progn
	  (let* ((request (dex:get url)) (processed-content (lquery:$ (initialize request)))
		 (pid-list (remove-if #'null (lquery:$ processed-content "article" (attr :id))))
		 (author-list (remove-if #'null (lquery:$ processed-content "article" (attr :data-author))))
		 (pc-list (map 'list #'(lambda (p) (elt (lquery:$ (inline (concatenate 'string "#" p)) "article" (text)) 0)) pid-list))
		 (posts (map 'list #'(lambda (a p) (make-post a p)) author-list pc-list)))
	    (mapc #'(lambda (p) (princ (funcall p)))  posts)))
	(format t "~A needs first argument to be an url.~%" (car sb-ext:*posix-argv*)))))
