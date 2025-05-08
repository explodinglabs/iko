create trigger modify
  after insert or update on contact
  for each row execute function modify_record();
