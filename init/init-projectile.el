(with-eval-after-load 'projectile
  (setq projectile-enable-caching t)
  )

(with-eval-after-load 'helm
  (add-to-list-multiple 'projectile-globally-ignored-files '("gems.tags" "tags"))
  (add-to-list-multiple 'helm-grep-ignored-directories '("tmp" "coverage"))
  )

(provide 'init-projectile)
