# Copy locales
cp -R config/locales/custom ../config/locales/custom/

# Copy routes
cp -R config/routes ../config/routes
cp config/routes.rb ../config/

# Copy database migration
cp db/migrate/2018010102070707_create_tests.rb ../db/migrate

# Copy spec/features/admin files over in order to manage who is of the new type
cp spec/features/admin/tests_spec.rb ../spec/features/admin

# Copy controllers, models, and views
cp -R app/controllers/custom ../app/controllers/custom/
cp -R app/models/custom ../app/models/custom/
cp -R app/views/custom ../app/views/custom/

# Copy admin_helper
cp app/helpers/admin_helper.rb ../app/helpers/admin_helper

