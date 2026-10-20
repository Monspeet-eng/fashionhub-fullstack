package seeder

import (
	"log"

	"fashionhub-backend/internal/model"

	"gorm.io/gorm"
)

func SeedDatabase(db *gorm.DB) {
	var count int64
	db.Model(&model.Category{}).Count(&count)
	if count > 0 {
		log.Println("Data seeder sudah ada, melewati proses seeding.")
		return
	}

	log.Println("Menjalankan database seeder untuk FashionHub...")

	menCat := model.Category{Name: "Men", Slug: "men"}
	womenCat := model.Category{Name: "Women", Slug: "women"}

	db.Create(&menCat)
	db.Create(&womenCat)

	products := []model.Product{
		// KATEGORI MEN (8 Produk)
		{
			CategoryID:  menCat.ID,
			Name:        "structured Oversized Trench Coat",
			Slug:        "structured-oversized-trench-coat",
			Description: "Mantel trench pria berpotongan modern oversized dengan bahan katun gabardine tahan angin. Cocok untuk tampilan kasual maupun semi-formal di musim hujan.",
			Price:       789000,
			Stock:       45,
			ImageURL:    "https://images.unsplash.com/photo-1516826957135-700dedea698c?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Essential Heavyweight Boxy Tee",
			Slug:        "essential-heavyweight-boxy-tee",
			Description: "Kaos pria dengan siluet boxy fit dari 100% combed cotton 280gsm yang lembut, tebal, dan mempertahankan bentuk seharian.",
			Price:       249000,
			Stock:       120,
			ImageURL:    "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Urban Utility Cargo Trousers",
			Slug:        "urban-utility-cargo-trousers",
			Description: "Celana kargo kontemporer dengan 6 saku fungsional dan bahan ripstop stretch yang nyaman untuk mobilitas tinggi.",
			Price:       459000,
			Stock:       80,
			ImageURL:    "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Vintage Washed Selvedge Denim Jacket",
			Slug:        "vintage-washed-selvedge-denim-jacket",
			Description: "Jaket denim pria 14oz dengan detail jahitan kontras dan efek washed klasik yang memberi karakter maskulin dan timeless.",
			Price:       649000,
			Stock:       55,
			ImageURL:    "https://images.unsplash.com/photo-1576871337622-98d48d1cf531?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Relaxed Linen Cuban Collar Shirt",
			Slug:        "relaxed-linen-cuban-collar-shirt",
			Description: "Kemeja kerah terbuka berbahan campuran linen Eropa yang sejuk dan breathable, sempurna untuk gaya santai akhir pekan.",
			Price:       349000,
			Stock:       95,
			ImageURL:    "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Merino Wool Knit Crewneck Sweater",
			Slug:        "merino-wool-knit-crewneck-sweater",
			Description: "Sweater rajut halus berbahan wol merino pilihan yang memberikan kehangatan optimal tanpa rasa gatal di kulit.",
			Price:       529000,
			Stock:       60,
			ImageURL:    "https://images.unsplash.com/photo-1614975058789-41316d0e2e9c?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Tailored Pleated Chino Pants",
			Slug:        "tailored-pleated-chino-pants",
			Description: "Celana chino dengan lipatan depan (front pleat) bergaya smart-casual yang rapi untuk kuliah maupun kerja.",
			Price:       419000,
			Stock:       100,
			ImageURL:    "https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  menCat.ID,
			Name:        "Minimalist Suede Bomber Jacket",
			Slug:        "minimalist-suede-bomber-jacket",
			Description: "Jaket bomber berbahan vegan suede lembut dengan ritsleting logam YKK dua arah dan lapisan dalam satin premium.",
			Price:       699000,
			Stock:       40,
			ImageURL:    "https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=800&q=80",
		},

		// KATEGORI WOMEN (8 Produk)
		{
			CategoryID:  womenCat.ID,
			Name:        "Satin Draped Midi Slip Dress",
			Slug:        "satin-draped-midi-slip-dress",
			Description: "Dress midi berbahan silk-satin mewah dengan detail kerah cowl neck yang anggun untuk acara malam maupun pesta kasual.",
			Price:       589000,
			Stock:       75,
			ImageURL:    "https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Double-Breasted Tailored Belted Blazer",
			Slug:        "double-breasted-tailored-belted-blazer",
			Description: "Blazer wanita berpotongan tegas dengan sabuk pinggang lepasan yang menciptakan siluet modern dan profesional.",
			Price:       749000,
			Stock:       50,
			ImageURL:    "https://images.unsplash.com/photo-1548624313-0396c75e4b1a?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "High-Waist Wide Leg Palazzo Trousers",
			Slug:        "high-waist-wide-leg-palazzo-trousers",
			Description: "Celana kulot high-waist berbahan tencel jatuh yang memberikan kesan kaki jenjang dan kenyamanan sepanjang hari.",
			Price:       449000,
			Stock:       110,
			ImageURL:    "https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Ribbed Cashmere Blend Cropped Cardigan",
			Slug:        "ribbed-cashmere-blend-cropped-cardigan",
			Description: "Kardigan rajut bertekstur rib dengan kancing mutiara imitasi, mudah dipadukan dengan rok maupun celana jeans.",
			Price:       389000,
			Stock:       85,
			ImageURL:    "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Pleated Asymmetric A-Line Midi Skirt",
			Slug:        "pleated-asymmetric-a-line-midi-skirt",
			Description: "Rok plisket asimetris dengan gerakan dinamis dan pinggang elastis tersembunyi yang pas di berbagai bentuk tubuh.",
			Price:       399000,
			Stock:       90,
			ImageURL:    "https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Poplin Oversized Button-Down Shirt",
			Slug:        "poplin-oversized-button-down-shirt",
			Description: "Kemeja katun poplin crisp dengan potongan relaxed fit yang serbaguna untuk gaya layering sehari-hari.",
			Price:       329000,
			Stock:       100,
			ImageURL:    "https://images.unsplash.com/photo-1551163943-3f6a855d1153?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Quilted Cropped Puffer Vest",
			Slug:        "quilted-cropped-puffer-vest",
			Description: "Rompi puffer ringan dengan jahitan diamond quilt dan kerah tinggi, cocok untuk tampilan streetwear kontemporer.",
			Price:       499000,
			Stock:       65,
			ImageURL:    "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80",
		},
		{
			CategoryID:  womenCat.ID,
			Name:        "Classic Belted Wool Blend Wrap Coat",
			Slug:        "classic-belted-wool-blend-wrap-coat",
			Description: "Coat panjang elegan berbahan campuran wol hangat dengan kerah lapel lebar dan ikat pinggang senada.",
			Price:       899000,
			Stock:       35,
			ImageURL:    "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=800&q=80",
		},
	}

	if err := db.Create(&products).Error; err != nil {
		log.Printf("Gagal melakukan seeding produk: %v", err)
		return
	}

	log.Printf("Berhasil melakukan seeding 2 kategori dan %d produk FashionHub.", len(products))
}
