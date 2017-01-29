(with-eval-after-load 'projectile
  (setq projectile-enable-caching t)
  (add-to-list 'projectile-globally-ignored-directories "-/*/node_modules")
  (add-to-list-multiple 'projectile-globally-ignored-files '("gems.tags" "tags"))
  )

(with-eval-after-load 'helm
  (add-to-list-multiple 'helm-grep-ignored-directories '("tmp" "coverage"))
  )

(provide 'init-projectile)
