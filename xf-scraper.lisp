(defpackage :xf-scraper
  (:use :cl)
  (:export :main))

(in-package :xf-scraper)

(defun make-post (author post)
  (let ((post-author author)
	(post-content (string-trim '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout) post)))
    (vector
     (lambda () post-author)
     (lambda () post-content))))

(defun render-post (post)
  (format t "User: ~A~%~%~A~%----------~%" (funcall (elt post 0)) (funcall (elt post 1))))

(defun main ()
  (let ((url (cadr sb-ext:*posix-argv*)))
    (if url
	(progn
	  (let* ((request (dex:get url)) (processed-content (lquery:$ (initialize request)))
		 (pid-list (remove-if #'null (lquery:$ processed-content "article" (attr :id))))
		 (author-list (remove-if #'null (lquery:$ processed-content "article" (attr :data-author))))
		 (pc-list (loop for p across pid-list collect
			       (elt (lquery:$ (inline (concatenate 'string "#" p)) "article" (text)) 0)))
		 (list-length (- (length pc-list) 1))
		 (posts
		  (loop for i from 0 to list-length collect
			 (make-post (elt author-list i) (elt pc-list i)))))
	    (map 'nil #'render-post posts)))
	(format t "~A needs first argument to be an url.~%" (car sb-ext:*posix-argv*)))))
