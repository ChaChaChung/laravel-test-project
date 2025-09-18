<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\MDL_Seo_Data;

class CTL_Seo_Data extends Controller
{
    function Get_Seo_Data()
    {
        $data = MDL_Seo_Data::select([
            'title',
            'description',
            'keywords'
        ])
        ->first();
        return $data;
    }
}
