select
  (storage.foldername('a1e1c0b0-2f5f-4f49-ab97-f77bd67d111a/profile.jpg'))[1] as folder,
  'a1e1c0b0-2f5f-4f49-ab97-f77bd67d111a' as auth_uid,
  (storage.foldername('a1e1c0b0-2f5f-4f49-ab97-f77bd67d111a/profile.jpg'))[1] 
    = 'a1e1c0b0-2f5f-4f49-ab97-f77bd67d111a' as rls_would_pass;