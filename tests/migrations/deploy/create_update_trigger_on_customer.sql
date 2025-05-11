create trigger update
  before insert or update on customer
  for each row execute function update_table();
