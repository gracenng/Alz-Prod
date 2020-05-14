package com.example.alzi;

import androidx.fragment.app.FragmentActivity;

import android.content.Intent;
import android.os.Bundle;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.CameraUpdateFactory;

import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

public class MainActivity extends FragmentActivity implements OnMapReadyCallback {
    private GoogleMap mMap;
    boolean Check = true;
    private SupportMapFragment mapFragment;
    private ImageView imageView;
    private final int PICK_IMAGE = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btn = (Button) findViewById(R.id.btnGetHome);
        Button azureBtn = (Button) findViewById(R.id.faceButton);
        imageView = findViewById(R.id.imageView1);

        mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);

        hideMapFragment();

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Check();
                hideMSImage();
                showMapFragment();
            }
        });

        azureBtn.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                showMSImage();
                hideMapFragment();
                Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                intent.setType("image/*");
                startActivityForResult(Intent.createChooser(
                        intent, "Select Picture"), PICK_IMAGE);
            }
        });
    }

    public void Check() {
        Log.d("TEST", "Printing to Console");
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        // Add a marker in Sydney, Australia, and move the camera.
        LatLng UniversityOfWaterloo = new LatLng(43.4653768, -80.5347836); // Waterloo coordinates

        if (mMap != null) {
            mMap.addMarker(new MarkerOptions().position(UniversityOfWaterloo).title("Marker at the University of Waterloo"));
            mMap.moveCamera(CameraUpdateFactory.newLatLng(UniversityOfWaterloo));
        }

        showMapFragment();
    }

    private void showMapFragment() {
        mapFragment.getView().setVisibility(View.VISIBLE);
    }

    private void hideMapFragment() {
        mapFragment.getView().setVisibility(View.GONE);
    }

    private void showMSImage() {
        imageView.setVisibility(View.VISIBLE);
    }

    private void hideMSImage() {
        imageView.setVisibility(View.GONE);
    }
}
