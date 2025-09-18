<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\MDL_Seo_Data;

class SeoDataSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        MDL_Seo_Data::create([
            'title' => 'Laravel Application',
            'description' => 'A powerful Laravel application with modern features.',
            'keywords' => 'laravel, php, web application, api'
        ]);
    }
}
